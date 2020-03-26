# Output variables from created compute instance
output "block_ocid" {
  value = "${oci_core_volume.TFBlock.id}"
}

output "instance_attached" {
  value = "${var.instance_ocid}"
}
