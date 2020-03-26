# If compartment not created: 
# use ${module.compartment.compartment_ocid}
module "compartment" {
  source = "./modules/compartment"
  tenancy_ocid = "${var.tenancy_ocid}"
  compartment_name = "test_compartment"
  description = "Test Compartment"
  enable_delete = "false" // true will cause this compartment to be deleted when running `terrafrom destroy`
}

module "vcn" {
  source = "./modules/vcn"
  compartment_ocid = "${var.compartment_ocid}"
  region = "us-ashburn-1"
  availability_domain = "${var.availability_domain}"
  prefix = "EBS"

  vcn_cidr_block = "10.0.0.0/16"
  pub_subnet_cidr_block = "10.0.0.0/24"
  priv_subnet_cidr_block = "10.0.1.0/24"
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

module "block" {
  source = "./modules/block"
  compartment_ocid = "${var.compartment_ocid}"
  tenancy_ocid = "${var.tenancy_ocid}"
  availability_domain = "${var.availability_domain}"
  instance_ocid = "${module.ebscompute.instance_ocid}"

  block_name = "EBS_BV"
  block_size_in_gb =  "200"

  ssh_private_key = "${file(var.ssh_private_key_path)}"
  public_ip = "${module.ebscompute.public_ip}"
}
