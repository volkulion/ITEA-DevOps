provider "google" {
  region = "${var.region}"
  project = "${var.project}"
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}


resource "google_compute_firewall" "default" {
  name    = "firewall-externalssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["externalssh"]
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "default" {
 name         = "itea-vm-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone         = "${var.zone}"

 boot_disk {
   initialize_params {
     image = "debian-cloud/debian-9"
   }
 }

 metadata ={
  ssh-keys = "${var.admin_username}:${file(var.ssh_public_key)}"
}

// Make sure flask is installed on all new instances for later steps
 metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }

 provisioner "remote-exec" {
        connection {
            host = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
            type = "ssh"
            user     = "${var.admin_username}"
            private_key = "${file(var.ssh_private_key)}"
            timeout = "120s"
           
        }

        inline = [
        "echo = ============== Hello, here we GO ===============",
        "ls -la"
        ]
    }
}
 

