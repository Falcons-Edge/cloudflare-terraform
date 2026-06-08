resource "cloudflare_record" "rec_waap-security-uk_cname_www" {
  zone_id = cloudflare_zone.zone_waap-security-uk.id
  name    = "www"
  type    = "CNAME"
  content = "waap-security-blog.pages.dev"
  proxied = true
  ttl     = 1
}

resource "cloudflare_zone" "zone_aisecurities-uk" {
  zone       = "aisecurities.uk"
  account_id = "ec9e1f01ae075124aea715fcae3783c7"
  plan       = "free"
  type       = "full"
}

resource "cloudflare_record" "rec_aisecurities-uk_cname_www" {
  zone_id = cloudflare_zone.zone_aisecurities-uk.id
  name    = "www"
  type    = "CNAME"
  content = "ai-securities-blog.pages.dev"
  proxied = true
  ttl     = 1
}

resource "cloudflare_zone" "zone_falcons-edge-com" {
  zone       = "falcons-edge.com"
  account_id = "ec9e1f01ae075124aea715fcae3783c7"
  plan       = "free"
  type       = "full"
}

resource "cloudflare_record" "rec_falcons-edge-com_cname_www" {
  zone_id = cloudflare_zone.zone_falcons-edge-com.id
  name    = "www"
  type    = "CNAME"
  content = "falcons-edge-web.pages.dev"
  proxied = true
  ttl     = 1
}

resource "cloudflare_record" "rec_falcons-edge-com_cname_dockingbay" {
  zone_id = cloudflare_zone.zone_falcons-edge-com.id
  name    = "dockingbay"
  type    = "A"
  content = "47.203.204.73"
  proxied = false
  ttl     = 1
}

resource "cloudflare_record" "rec_falcons-edge-com_cname_bridge" {
  zone_id = cloudflare_zone.zone_falcons-edge-com.id
  name    = "bridge"
  type    = "CNAME"
  content = "1c69a9fa-de3c-46ce-8697-a6af8737a8af.cfargotunnel.com"
  proxied = true
  ttl     = 1
}

resource "cloudflare_record" "rec_falcons-edge-com_cname_drop" {
  zone_id = cloudflare_zone.zone_falcons-edge-com.id
  name    = "drop"
  type    = "CNAME"
  content = "1c69a9fa-de3c-46ce-8697-a6af8737a8af.cfargotunnel.com"
  proxied = true
  ttl     = 1
}

resource "cloudflare_record" "rec_falcons-edge-com_mx_root" {
  zone_id   = cloudflare_zone.zone_falcons-edge-com.id
  name      = "falcons-edge.com"
  type      = "MX"
  content   = "mx.zoho.com"
  priority  = 1
  proxied   = false
  ttl       = 1
}

resource "cloudflare_record" "rec_falcons-edge-com_txt_root" {
  zone_id = cloudflare_zone.zone_falcons-edge-com.id
  name    = "falcons-edge.com"
  type    = "TXT"
  content = "\"zoho-verification=zb62236366.zmverify.zoho.com\""
  proxied = false
  ttl     = 600
}

resource "cloudflare_zone" "zone_microsegmentation-uk" {
  zone       = "microsegmentation.uk"
  account_id = "ec9e1f01ae075124aea715fcae3783c7"
  plan       = "free"
  type       = "full"
}

resource "cloudflare_zone" "zone_aiforrealestateagents-uk" {
  zone       = "aiforrealestateagents.uk"
  account_id = "ec9e1f01ae075124aea715fcae3783c7"
  plan       = "free"
  type       = "full"
}

resource "cloudflare_record" "rec_aiforrealestateagents-uk_cname_root" {
  zone_id = cloudflare_zone.zone_aiforrealestateagents-uk.id
  name    = "@"
  type    = "CNAME"
  content = "real-estate-ai-affiliate.pages.dev"
  proxied = true
  ttl     = 1
}

resource "cloudflare_record" "rec_aiforrealestateagents-uk_cname_www" {
  zone_id = cloudflare_zone.zone_aiforrealestateagents-uk.id
  name    = "www"
  type    = "CNAME"
  content = "real-estate-ai-affiliate.pages.dev"
  proxied = true
  ttl     = 1
}

resource "cloudflare_record" "rec_microsegmentation-uk_cname_www" {
  zone_id = cloudflare_zone.zone_microsegmentation-uk.id
  name    = "www"
  type    = "CNAME"
  content = "microsegmentation-blog.pages.dev"
  proxied = true
  ttl     = 1
}

resource "cloudflare_zone" "zone_waap-security-uk" {
  zone       = "waap-security.uk"
  account_id = "ec9e1f01ae075124aea715fcae3783c7"
  plan       = "free"
  type       = "full"
}
