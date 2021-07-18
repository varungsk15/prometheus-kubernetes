data "terraform_remote_state" "service_account" {
  backend = "gcs"
  config = {
    bucket  = "varunbackend"
    prefix  = "terraform.tfstate"
  }
}

locals {
  project = var.project_name
  region  = "us-central1"
}

data "google_client_config" "this" {}


# Start the application cluster
module "application_cluster" {
  source = "../../modules/cluster"

  cluster_name                          = "stage"
  master_version                        = "1.19.9-gke.1900"
  project                               = local.project
  network                               = var.network
  sub_network                           = var.subnet
  region                                = local.region
  zones                                 = [
                                            "${local.region}-b",
                                            "${local.region}-c",
                                            "${local.region}-f"
                                          ]
  master_ipv4_cidr_block                = "10.3.0.0/28"
  max_worker_nodes                      = "2"
  min_worker_nodes                      = "1"
  default_max_pods_per_node             = "64"
  monitoring_service                    = "monitoring.googleapis.com/kubernetes"
  logging_service                       = "logging.googleapis.com/kubernetes"
}

module "application_nodepool_workers_np" {
  source = "../../modules/node_pool"

  name                    = "workers"
  project                 = local.project
  location                = local.region
  cluster_name            = module.application_cluster.cluster_name
  max_worker_nodes        = "3"
  min_worker_nodes        = "1"
  initial_node_count      = "1"

  max_surge               = "0"
  max_unavailable         = "1"
  image_type              = "UBUNTU"
  machine_type            = "n1-standard-2"
  disk_type               = "pd-ssd"
  disk_size               = "50"
  service_account         = null
  node_pool_network_tags  = []
  node_pool_labels        = {
                              "dou/student-name": "varun-senthilkumar"
                            }
  node_locations          = [
                              "us-central1-a"
                            ]
}








// 2nd assignment GCP

# resource "google_compute_instance" "default" {
#   project      = local.project
#   name        = "edge-case-varun-senthilkumar"
#   description = "This template is used to create app server instances."
#
#   labels = {
#     environment = "dev"
#   }
#   machine_type         = "n1-standard-1"
#   zone                 = "us-central1-a"
#
#   // Create a new boot disk from an image
#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-9"
#     }
#   }
#
#
#   network_interface {
#     subnetwork = var.subnet
#   }
# }


// 3rd assignment

# resource "google_service_account" "k8s" {
#   account_id = "edge-case-varun-senthilkumar"
#   project    = local.project
# }
#
#
# module "dedicated_nodepool" {
#   // third example about this https://gitlab.com/DigitalOnUs/krollege-devops/-/blob/master/02%20-%20GCP/03-GKE-dedicated-nodepool.md
#   source = "../../modules/node_pool"
#
#   name               = "dedicated"
#   project            = local.project
#   location           = local.region
#   cluster_name       = module.application_cluster.cluster_name
#   max_worker_nodes   = "1"
#   min_worker_nodes   = "1"
#   initial_node_count = "1"
#
#   max_surge              = "0"
#   max_unavailable        = "1"
#   image_type             = "UBUNTU"
#   machine_type           = "n1-standard-1"
#   disk_type              = "pd-ssd"
#   disk_size              = "50"
#   service_account        = google_service_account.k8s.email
#   node_pool_network_tags = []
#   node_pool_labels = {
#     "dou/student-name" : "varun-senthilkumar",
#     "dou/app-name" : "infraSpecificApp"
#   }
#   taints = [
#     {
#       "key" : "dou/app-name",
#       "value" : "infraSpecificApp",
#       "effect" : "NO_EXECUTE"
#     }
#   ]
#   node_locations = [
#     "us-central1-a"
#   ]
# }
