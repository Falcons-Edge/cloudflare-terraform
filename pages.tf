resource "cloudflare_pages_project" "ai_securities_blog" {
  account_id        = "ec9e1f01ae075124aea715fcae3783c7"
  name              = "ai-securities-blog"
  production_branch = "master"
  build_config {
    build_command   = "git submodule update --init --recursive && hugo --minify"
    destination_dir = "public"
    root_dir        = ""
  }
  source {
    type = "github"
    config {
      owner                         = "Falcons-Edge"
      repo_name                     = "ai-securities-blog"
      production_branch             = "master"
      pr_comments_enabled           = true
      preview_deployment_setting    = "all"
      preview_branch_includes       = ["*"]
      deployments_enabled           = true
      production_deployment_enabled = true
    }
  }
}

resource "cloudflare_pages_project" "microsegmentation_blog" {
  account_id        = "ec9e1f01ae075124aea715fcae3783c7"
  name              = "microsegmentation-blog"
  production_branch = "main"
  build_config {
    build_command   = "git submodule update --init --recursive && hugo --minify"
    destination_dir = "public"
    root_dir        = ""
  }
  source {
    type = "github"
    config {
      owner                         = "Falcons-Edge"
      repo_name                     = "microsegmentation-blog"
      production_branch             = "main"
      pr_comments_enabled           = true
      preview_deployment_setting    = "all"
      preview_branch_includes       = ["*"]
      deployments_enabled           = true
      production_deployment_enabled = true
    }
  }
}

resource "cloudflare_pages_project" "waap_security_blog" {
  account_id        = "ec9e1f01ae075124aea715fcae3783c7"
  name              = "waap-security-blog"
  production_branch = "master"
  build_config {
    build_command   = "git submodule update --init --recursive && hugo --minify"
    destination_dir = "public"
    root_dir        = ""
  }
  source {
    type = "github"
    config {
      owner                         = "Falcons-Edge"
      repo_name                     = "waap-security-blog"
      production_branch             = "master"
      pr_comments_enabled           = true
      preview_deployment_setting    = "all"
      preview_branch_includes       = ["*"]
      deployments_enabled           = true
      production_deployment_enabled = true
    }
  }
}

resource "cloudflare_pages_project" "falcons_edge_web" {
  account_id        = "ec9e1f01ae075124aea715fcae3783c7"
  name              = "falcons-edge-web"
  production_branch = "main"
  source {
    type = "github"
    config {
      owner                         = "Falcons-Edge"
      repo_name                     = "falcons-edge-web"
      production_branch             = "main"
      pr_comments_enabled           = true
      preview_deployment_setting    = "none"
      preview_branch_includes       = ["*"]
      deployments_enabled           = true
      production_deployment_enabled = true
    }
  }
}

resource "cloudflare_pages_domain" "real_estate_ai_affiliate_custom" {
  account_id   = "ec9e1f01ae075124aea715fcae3783c7"
  project_name = cloudflare_pages_project.real_estate_ai_affiliate.name
  domain       = "aiforrealestateagents.uk"
}

resource "cloudflare_pages_domain" "real_estate_ai_affiliate_www" {
  account_id   = "ec9e1f01ae075124aea715fcae3783c7"
  project_name = cloudflare_pages_project.real_estate_ai_affiliate.name
  domain       = "www.aiforrealestateagents.uk"
}

resource "cloudflare_pages_project" "real_estate_ai_affiliate" {
  account_id        = "ec9e1f01ae075124aea715fcae3783c7"
  name              = "real-estate-ai-affiliate"
  production_branch = "master"
  build_config {
    build_command   = "git submodule update --init --recursive && hugo --minify"
    destination_dir = "public"
    root_dir        = ""
  }
  source {
    type = "github"
    config {
      owner                         = "Falcons-Edge"
      repo_name                     = "real-estate-ai-affiliate"
      production_branch             = "master"
      pr_comments_enabled           = true
      preview_deployment_setting    = "all"
      preview_branch_includes       = ["*"]
      deployments_enabled           = true
      production_deployment_enabled = true
    }
  }
}
