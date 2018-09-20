variable "compartment_ocid" {}
variable "instance_ocid" {}
variable "display_name" {}

resource "oci_core_image" "test_image" {
	#Required
	compartment_id = "${var.compartment_ocid}"
	instance_id = "${var.instance_ocid}"

	#Optional
	display_name = "${var.display_name}"
}
