variable "compartment_ocid" {}
variable "tenancy_ocid" {}
variable "availability_domain" {}
variable "instance_ocid" {} 

variable "block_name" {}
variable "block_size_in_gb" {}

data "oci_core_volume_backup_policies" "test_volume_backup_policies" {
    #Optional
    compartment_id = "${var.compartment_ocid}"
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = "${var.tenancy_ocid}"
}

resource "oci_core_volume" "TFBlock" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain],"name")}" 
  compartment_id = "${var.compartment_ocid}"
  display_name = "${var.block_name}"
  size_in_gbs = "${var.block_size_in_gb}"

  backup_policy_id = "${data.oci_core_volume_backup_policies.test_volume_backup_policies.volume_backup_policies.0.id}"
}
  
resource "oci_core_volume_attachment" "TFBlockAttach" {
    attachment_type = "iscsi"
    compartment_id = "${var.compartment_ocid}"
    instance_id = "${var.instance_ocid}"
    volume_id = "${oci_core_volume.TFBlock.id}"
}
