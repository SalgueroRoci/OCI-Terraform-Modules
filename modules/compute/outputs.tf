# Output variables from created compute instance
output "instance_ocid" {
  value = "${oci_core_instance.TFInstance.id}"
}

output "public_ip" {
  value = "${oci_core_instance.TFInstance.public_ip}"
}
