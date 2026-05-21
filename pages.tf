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
