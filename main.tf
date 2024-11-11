# module "jenkins" {
#   source  = "terraform-google-modules/jenkins/google"
#   version = "1.2.0"
#   jenkins_instance_network = "projects/base43-it-network-shared1/global/networks/shared-vpc"
#   jenkins_instance_subnetwork = "projects/base43-it-network-shared1/regions/us-east1/subnetworks/subnet-1"
#   jenkins_instance_zone = "us-east1-b"
#   jenkins_workers_network = "projects/base43-it-network-shared1/global/networks/shared-vpc"
#   jenkins_workers_project_id = "rga-gcp-tech-assessment"
#   jenkins_workers_region = "us-east1"
#   project_id = "rga-gcp-tech-assessment"
#   region = "us-east1"
# }


# module "static-assets_cloud-storage-static-website" {
#   source  = "gruntwork-io/static-assets/google//modules/cloud-storage-static-website"
#   version = "0.6.0"
  
#   project = "rga-gcp-tech-assessment"
#   website_domain_name = "test.base43.com.br"
#   force_destroy_access_logs_bucket = true
#   force_destroy_website = true
# }

resource "google_compute_ssl_certificate" "static_web_cert" {
  project     = "rga-gcp-tech-assessment"
  name        = "static-web-cert"
  private_key = file("/home/bruno/rga-tech-assessment/jenkins/private.key")
  certificate = file("/home/bruno/rga-tech-assessment/jenkins/base43-cert.pem")
  lifecycle {
    create_before_destroy = true
  }
}

module "static-assets_http-load-balancer-website" {
  source  = "gruntwork-io/static-assets/google//modules/http-load-balancer-website"
  version = "0.6.0"
  
  project = "rga-gcp-tech-assessment"
  website_domain_name = "test.base43.com.br"
  force_destroy_access_logs_bucket = true
  force_destroy_website = true

  enable_ssl = true
  ssl_certificate = google_compute_ssl_certificate.static_web_cert.self_link
}