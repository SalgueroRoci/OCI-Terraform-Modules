variable "compartment_ocid" {}
variable "compute_display_name" {}
variable "instance_shape" {}
variable "image_ocid" {}
variable "subnet_ocid" {}
variable "ssh_public_key" {}
variable "availability_domain" {}

resource "oci_core_instance" "compute_instance" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "${var.compute_display_name}"
  shape = "${var.instance_shape}"
  image = "${var.image_ocid}"
  subnet_id = "${var.subnet_ocid}"

  metadata = {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }

  timeouts = {
    create = "60m"
  }
}
