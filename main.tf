locals {
  name = "base43"
  domain = "test.base43.com.br"
  project = "rga-gcp-tech-assessment"
  ssl = true
}

resource "google_compute_managed_ssl_certificate" "default" {
  name = "${local.name}test-cert"
  project = local.project

  managed {
    domains = ["test.base43.com.br."]
  }
}

resource "google_storage_default_object_acl" "public_rule" {
  bucket = module.static-assets_http-load-balancer-website.website_bucket_name
  role_entity = [ "READER:allUsers" ]
}

resource "google_storage_object_acl" "image-store-acl" {
  bucket = module.static-assets_http-load-balancer-website.website_bucket_name
  object = google_storage_bucket_object.indexpage.name

  role_entity = [
    "READER:allUsers"
  ]
}

module "static-assets_http-load-balancer-website" {
  source  = "gruntwork-io/static-assets/google//modules/http-load-balancer-website"
  version = "0.6.0"
  
  project = local.project
  website_domain_name = local.domain
  force_destroy_access_logs_bucket = true
  force_destroy_website = true
  //website_acls = ["READER:allUsers"]

  enable_ssl = true
  ssl_certificate = google_compute_managed_ssl_certificate.default.self_link
}