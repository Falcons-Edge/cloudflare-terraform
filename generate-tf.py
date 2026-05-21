#!/usr/bin/env python3
"""
Cloudflare → Terraform generator (v2)
Handles zone-scoped token permissions properly.
"""
import subprocess, json, urllib.request, os, sys

result = subprocess.run(
    ["gpg", "--decrypt", os.path.expanduser("~/.hermes/secrets/secrets.txt.gpg")],
    capture_output=True, text=True, timeout=10
)
token = None
for line in result.stdout.strip().split('\n'):
    if line.startswith('CLOUDFLARE_API_TOKEN='):
        token = line.split('=', 1)[1]
        break

ACCOUNT_ID = "ec9e1f01ae075124aea715fcae3783c7"
BASE = "https://api.cloudflare.com/client/v4"
HEADERS = {"Authorization": f"Bearer {token}"}
CF_DIR = os.path.expanduser("~/Repos/Falcons-Edge/cf-cloudflare")

def cf_get(path, desc="resource"):
    try:
        req = urllib.request.Request(f"{BASE}{path}", headers=HEADERS)
        resp = urllib.request.urlopen(req, timeout=15)
        data = json.loads(resp.read())
        if not data.get('success'):
            print(f"  ⚠ {desc}: API error - {data.get('errors', [{}])[0].get('message', '?')}")
            return []
        return data.get('result', [])
    except urllib.request.HTTPError as e:
        body = json.loads(e.read())
        msg = body.get('errors', [{}])[0].get('message', str(e.code))
        print(f"  ⚠ {desc}: {e.code} - {msg}")
        return []

def write_file(path, content):
    full = os.path.join(CF_DIR, path)
    os.makedirs(os.path.dirname(full), exist_ok=True)
    with open(full, 'w') as f:
        f.write(content)
    print(f"  ✓ wrote {path}")

# ─── Zones ───────────────────────────────────────────────────────
zones = cf_get("/zones?per_page=50", "zones")
print(f"\nFound {len(zones)} zones\n")

zone_blocks = []
imports = []

for z in zones:
    zid = z['id']
    zname = z['name']
    saname = zname.replace('.', '-')
    
    zone_blocks.append(f'''
resource "cloudflare_zone" "zone_{saname}" {{
  zone = "{zname}"
  plan = "free"
  type = "full"
}}''')
    imports.append(f'terraform import cloudflare_zone.zone_{saname} {zid}')
    
    # ─── DNS Records (zone-scoped - may 403) ─────────────────
    records = cf_get(f"/zones/{zid}/dns_records?per_page=100", f"DNS records for {zname}")
    print(f"  {zname}: {len(records)} DNS records")
    
    for i, r in enumerate(records):
        rname = r['name'].rstrip(f".{zname}").rstrip('.')
        if not rname:
            rname = '@'
        
        safe_name = f"rec_{saname}_{r['type'].lower()}_{rname.replace('.', '-').replace('@', 'root')}"[:100]
        safe_name = safe_name.lower().strip('-')
        
        # Handle different record types
        if r['type'] in ('A', 'AAAA', 'CNAME', 'TXT', 'NS'):
            val = r['content'].replace('"', '\\"')
            hcl = f'''
resource "cloudflare_record" "{safe_name}" {{
  zone_id = cloudflare_zone.zone_{saname}.id
  name    = "{rname}"
  type    = "{r['type']}"
  value   = "{val}"
  proxied = {"true" if r.get('proxied') else "false"}
  ttl     = {r.get('ttl', 1)}
}}'''
        elif r['type'] == 'MX':
            hcl = f'''
resource "cloudflare_record" "{safe_name}" {{
  zone_id   = cloudflare_zone.zone_{saname}.id
  name      = "{rname}"
  type      = "{r['type']}"
  value     = "{r['content']}"
  priority  = {r.get('priority', 10)}
  proxied   = false
  ttl       = {r.get('ttl', 1)}
}}'''
        elif r['type'] == 'CAA':
            hcl = f'''
resource "cloudflare_record" "{safe_name}" {{
  zone_id = cloudflare_zone.zone_{saname}.id
  name    = "{rname}"
  type    = "{r['type']}"
  data = {{
    flags  = "{r['data'].get('flags', '0')}"
    tag    = "{r['data'].get('tag', '')}"
    value  = "{r['data'].get('value', '')}"
  }}
  proxied = false
  ttl     = {r.get('ttl', 1)}
}}'''
        else:
            print(f"    ↪ skipping {r['type']} record {rname} (unsupported type)")
            continue
        
        zone_blocks.append(hcl)
        imports.append(f'terraform import cloudflare_record.{safe_name} {zid}/{r["id"]}')
    
    # ─── Zone Settings ──────────────────────────────────────────
    zone_blocks.append(f'''
resource "cloudflare_zone_settings_override" "zone_{saname}_settings" {{
  zone_id = cloudflare_zone.zone_{saname}.id
  settings {{
    ssl         = "flexible"
    ipv6        = "on"
    http2       = "on"
    tls_1_3     = "on"
    min_tls_version = "1.2"
    automatic_https_rewrites = "on"
    opportunistic_encryption = "on"
  }}
}}''')
    imports.append(f'terraform import cloudflare_zone_settings_override.zone_{saname}_settings {zid}')

# ─── Pages Projects ──────────────────────────────────────────────
pages = cf_get(f"/accounts/{ACCOUNT_ID}/pages/projects", "Pages projects")
print(f"\nPages: {len(pages)} projects\n")

pages_blocks = []
for p in pages:
    pname = p['name']
    saname = pname.replace('-', '_')
    pages_blocks.append(f'''
resource "cloudflare_pages_project" "{saname}" {{
  account_id        = "{ACCOUNT_ID}"
  name              = "{pname}"
  production_branch = "{p.get('production_branch', 'main')}"
  build_config {{
    build_command   = "{p.get('build_config', {}).get('build_command', '')}"
    destination_dir = "{p.get('build_config', {}).get('destination_dir', '')}"
    root_dir        = "{p.get('build_config', {}).get('root_dir', '')}"
    web_analytics_tag  = "{p.get('build_config', {}).get('web_analytics_tag', '')}"
    web_analytics_token = "{p.get('build_config', {}).get('web_analytics_token', '')}"
  }}
  deployment_configs {{
    preview {{
      env_vars = {{}}
    }}
    production {{
      env_vars = {{}}
    }}
  }}
}}''')
    imports.append(f'terraform import cloudflare_pages_project.{saname} {ACCOUNT_ID}/{pname}')

# ─── Write all files ─────────────────────────────────────────────
write_file("zones.tf", '\n'.join(zone_blocks))
write_file("pages.tf", '\n'.join(pages_blocks))

# Provider config
write_file("versions.tf", '''
terraform {
  required_version = ">= 1.6"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
''')

write_file("variables.tf", '''
variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}
''')

# Import script
import_script = '#!/usr/bin/env bash\n# Import all Cloudflare resources into Terraform state\nset -euo pipefail\ncd "$(dirname "$0")"\n' + '\n'.join(imports)
write_file("import.sh", import_script)
os.chmod(os.path.join(CF_DIR, "import.sh"), 0o755)

write_file("terraform.tfvars.example", '# Copy to terraform.tfvars and fill in:\n# cloudflare_api_token = "your-token"\n# Or just set CLOUDFLARE_API_TOKEN env var\n')

print(f"\n{'='*50}")
print(f"Done! Generated {len(zone_blocks)} HCL blocks + {len(pages_blocks)} Pages blocks")
print(f"Total import commands: {len(imports)}")
print(f"\nNext steps:")
print(f"  1. source <(gpg --decrypt ~/.hermes/secrets/secrets.txt.gpg 2>/dev/null)")
print(f"  2. cd ~/Repos/Falcons-Edge/cf-cloudflare")
print(f"  3. bash import.sh")
print(f"  4. terraform plan")
