variable "compartment_ocid" {}
variable "instance_ocid" {} 
variable "availability_domain" {}
variable "tenancy_ocid" {}

data "oci_identity_availability_domains" "ads" {
  compartment_id = "${var.tenancy_ocid}"
}


resource "oci_core_volume" "TFBlock0" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain],"name")}" 
  compartment_id = "${var.compartment_ocid}"
  display_name = "TFBlock0"
  size_in_gbs = "4000"
}
  
resource "oci_core_volume_attachment" "TFBlockAttach" {
    attachment_type = "iscsi"
    compartment_id = "${var.compartment_ocid}"
    instance_id = "${var.instance_ocid}"
    volume_id = "${oci_core_volume.TFBlock0.id}"
}
