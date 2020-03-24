variable "compartment_ocid" {}
variable "compute_display_name" {}
variable "instance_shape" {}
variable "subnet_ocid" {}
variable "ssh_public_key" {}
variable "availability_domain" {}
variable "tenancy_ocid" {}
variable "instance__boot_volume_size" {}
variable "region" {}
variable "instance_image_ocid" {
  type = "map"
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = "${var.tenancy_ocid}"
}

resource "oci_core_instance" "TFInstance" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain],"name")}" 
  compartment_id = "${var.compartment_ocid}"
  shape = "${var.instance_shape}"
  display_name = "${var.compute_display_name}"

  create_vnic_details {
      #Required
      subnet_id = "${var.subnet_ocid}"
  }

  defined_tags = {"project"= "ebs", "owner" = "rocio"}

  source_details {
      #Required
      source_id   = "${var.instance_image_ocid[var.region] }"
      source_type = "image"

      #Optional
      boot_volume_size_in_gbs = "${var.instance__boot_volume_size}"
  }

  metadata = {
      ssh_authorized_keys = "${var.ssh_public_key}"
  }
}
