variable "bucket_name" {}
variable "namespace" {}
variable "object_name" {}
variable "compartment_ocid" {}
variable "display_name" {}

resource "oci_core_image" "test_image" {
  //provisioner "local-exec" {
  //  command = "oci"
  //}	

  compartment_id = "${var.compartment_ocid}"
  display_name = "${var.display_name}"
  image_source_details {
    source_type = "objectStorageTuple"
    bucket_name = "${var.bucket_name}"
    namespace_name = "${var.namespace}"
    object_name = "${var.object_name}" # exported image name
  }
}
