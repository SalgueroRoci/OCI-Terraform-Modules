output "public_subnet_ocid" {
  value = "${oci_core_subnet.subnet_private.id}"
}
output "private_subnet_ocid" {
  value = "${oci_core_subnet.subnet_public.id}"
}
output "vcn_ocid" {
  value = "${oci_core_virtual_network.vcn.id}"
}
