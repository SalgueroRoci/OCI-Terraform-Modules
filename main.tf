module "vcn" {
  source = "./modules/vcn"
  user_ocid = "${var.user_ocid}"
  tenancy_ocid = "${var.tenancy_ocid}"
  compartment_ocid = "${var.cloud_compartment_ocid}"
  ssh_public_key_path = "${var.ssh_public_key_path}"
  ssh_private_key_path = "{var.ssh_private_key_path}"
  fingerprint = "${var.fingerprint}"
  region = "us-ashburn-1"
  availability_domain = "${var.availability_domain}"
}

module "bucket" {
  source = "./modules/bucket"
  compartment_ocid = "${var.cloud_compartment_ocid}"
}

module "create_image" {
  source = "./modules/create_image"
  compartment_ocid = "${var.customer_compartment_ocid}"
  instance_ocid = "${var.instance_ocid}"
  display_name = "image_9_20_18"

}

module "image_migration" {
  source = "./modules/image_migration"
  compartment_ocid = "${var.cloud_compartment_ocid}"
  bucket_name = "tf-example-bucket"
  namespace = "gse00015177"
  object_name = "image_9_20_18"
 
  display_name = "image_9_20_18"
}

module "compute" {
  source = "./modules/compute"
  compartment_ocid = "${var.cloud_compartment_ocid}"
  compute_display_name = "compute_test"
  instance_shape = "VM.DenseIO1.4"
  image_ocid = "${module.image_migration.image_ocid}"
  subnet_ocid = "${module.vcn.subnet_ocid}"
  ssh_public_key = "${var.ssh_public_key}"
  tenancy_ocid = "${var.tenancy_ocid}"
  availability_domain = "${var.availability_domain}"
}
