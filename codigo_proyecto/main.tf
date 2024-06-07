provider "google" {
  credentials = file("service_account.json")
  project     = var.project
  region      = var.region
}

terraform {
  backend "gcs" {
    bucket      = "capstonebucket-jd"
    prefix      = "terraform/state"
    credentials = "service_account.json"
  }
}


////////////////////////////////////////////////////////////////


resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

provider "kubernetes" {
  host                   = google_container_cluster.primary.endpoint
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}


resource "google_container_cluster" "primary" {
  name                = "capstone-cluster"
  location            = "us-central1-a"
  initial_node_count  = 2
  deletion_protection = false
  node_config {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      foo = "bar"
    }
    tags = ["foo", "bar"]
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}


resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  location   = "us-central1-a"
  cluster    = google_container_cluster.primary.name
  node_count = 2

  node_config {
    preemptible  = true
    machine_type = "e2-standard-2"
  }
}



/////////////////////// LOAD BALANCER /////////////////////////

data "google_compute_global_address" "default" {
  name = "ip-capstone-global"
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = "${var.network_prefix}-rule"
  target     = google_compute_target_http_proxy.default.self_link
  ip_address = data.google_compute_global_address.default.address
  port_range = "80"
}


# proxy para el LB
resource "google_compute_target_http_proxy" "default" {
  name    = "${var.network_prefix}-proxy"
  url_map = google_compute_url_map.default.self_link
}

# enruta el tráfico HTTP al backend
resource "google_compute_url_map" "default" {
  name            = "${var.network_prefix}-map"
  default_service = google_compute_backend_service.default.self_link
}

# define el tráfico en el backend, en este caso al grupo de instancias
resource "google_compute_backend_service" "default" {
  name          = "backend-service"
  health_checks = [google_compute_http_health_check.default.id]
}

resource "google_compute_http_health_check" "default" {
  name               = "health-check"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}

output "load_balancer_ip_address" {
  description = "IP address of the Cloud Load Balancer"
  value       = data.google_compute_global_address.default.address
}
