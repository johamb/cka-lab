provider "google" {
    project = "cka-training-337214"
    region  = "europe-west3"
    zone    = "europe-west3-c"
}

data "google_compute_image" "ubuntu" {
  family  = "ubuntu-1804-lts"
  project = "ubuntu-os-cloud"
}

resource "google_compute_network" "vpc" {
    name = "vpc"
}

resource "google_compute_firewall" "vpc-firewall" {
    name = "vpc-firewall"
    network = google_compute_network.vpc.name
    source_ranges = ["0.0.0.0/0"]
    allow {
        protocol = "all"
    }
}

resource "google_compute_instance" "master" {
    name         = "master-tf"
    machine_type = "e2-standard-2"
    network_interface {
      network = google_compute_network.vpc.name
    }
    boot_disk {
        initialize_params {
            image = data.google_compute_image.ubuntu.name
            size = 40
            type = "pd-balanced"
        }
    }
}

resource "google_compute_instance" "worker" {
    name         = "worker-tf"
    machine_type = "e2-standard-2"
    network_interface {
      network = google_compute_network.vpc.name
    }
    boot_disk {
        initialize_params {
            image = data.google_compute_image.ubuntu.name
            size = 10
            type = "pd-balanced"
        }
    }
}
