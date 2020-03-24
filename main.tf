module "vcn" {
  source = "./modules/vcn"
  compartment_ocid = "${var.compartment_ocid}"
  region = "us-ashburn-1"
  availability_domain = "${var.availability_domain}"
}

module "ebscompute" {
  source = "./modules/compute"
  compartment_ocid = "${var.compartment_ocid}"
  tenancy_ocid = "${var.tenancy_ocid}"
  subnet_ocid = "${module.vcn.private_subnet_ocid}"
  availability_domain = "${var.availability_domain}"
  region = "${var.region}"
  instance_image_ocid = "${var.instance_image_ocid}"

  ssh_public_key = "${var.ssh_public_key}"
  instance_shape = "VM.Standard2.2"
  compute_display_name = "EBS Compute"
  instance__boot_volume_size = "300"
}
output "ebsinfo" {
  value = "${module.ebscompute.public_ip}"
}
module "bastion" {
  source = "./modules/compute"
  compartment_ocid = "${var.compartment_ocid}"
  tenancy_ocid = "${var.tenancy_ocid}"
  subnet_ocid = "${module.vcn.public_subnet_ocid}"
  availability_domain = "${var.availability_domain}"
  region = "${var.region}"
  instance_image_ocid = "${var.instance_image_ocid}"

  ssh_public_key = "${var.ssh_public_key}"
  instance_shape = "VM.StandardE2.1"
  compute_display_name = "EBS Bastion"
  instance__boot_volume_size = "50"
}

# module "block" {
#   source = "./modules/block"
#   compartment_ocid = "${var.cloud_compartment_ocid}"
#   tenancy_ocid = "${var.tenancy_ocid}"
#   compartment_ocid = "${var.cloud_compartment_ocid}"
#   instance_ocid = "${module.compute.instance_ocid}"
#   availability_domain = "${var.availability_domain}"
#   ssh_private_key = "${file(var.ssh_private_key_path)}"
#   public_ip = "${module.compute.public_ip}"
# }
