variable "private_key_path" {}
variable "ssh_private_key_path" {}
variable "ssh_public_key_path" {}
variable "customer_compartment_ocid" {}
variable "cloud_compartment_ocid" {}
variable "tenancy_ocid" {}
variable "fingerprint" {}
variable "region" {}
variable "user_ocid" {}
variable "ssh_public_key" {}
variable "instance_count" {
  default="1"
}
variable "availability_domain" {
  default="0"
}

variable "instance_ocid" {}
