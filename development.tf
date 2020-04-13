module "dev_compartment" {
  source = "./modules/compartment"
  tenancy_ocid = var.tenancy_ocid
  compartment_name = "Development"
  description = "Compartment for Non-Production / Test"
  enable_delete = "false" // true will cause this compartment to be deleted when running `terrafrom destroy`
}

module "dev_subnets" {
  source = "./modules/subnets"
  compartment_ocid = module.dev_compartment.compartment_ocid
  vcn_ocid = module.vcn.vcn_ocid
  rt_public = module.vcn.public_rt_ocid
  rt_private = module.vcn.private_rt_ocid
  default_dhcp_ocid = module.vcn.default_dhcp_ocid

  prefix = "dev"
  vcn_cidr_block = "10.0.0.0/16" 
  public_subnet_cidr_block = "10.0.3.0/24"
  private_subnet_cidr_block = "10.0.4.0/24"
  db_subnet_cidr_block = "10.0.5.0/24"

}

// Development workloads, Bastion, SFTP, Script, EDQ, Database
module "edq_dev" {
  source = "./modules/compute"
  compartment_ocid = module.dev_compartment.compartment_ocid
  tenancy_ocid = var.tenancy_ocid
  subnet_ocid = module.dev_subnets.public_subnet_ocid
  availability_domain = var.availability_domain
  region = var.region
  instance_image_ocid = local.edq_image

  ssh_public_key = var.ssh_public_key
  instance_shape = "VM.Standard2.2"
  compute_display_name = "Dev EDQ"
  instance__boot_volume_size = "50"
}

module "bastion_dev" {
  source = "./modules/compute"
  compartment_ocid = module.dev_compartment.compartment_ocid
  tenancy_ocid = var.tenancy_ocid
  subnet_ocid = module.dev_subnets.public_subnet_ocid
  availability_domain = var.availability_domain
  region = var.region
  instance_image_ocid = local.cent_os_7[var.region]

  ssh_public_key = var.ssh_public_key
  instance_shape = "VM.Standard2.2"
  compute_display_name = "Dev Bastion"
  instance__boot_volume_size = "50"
}

module "sftp_dev" {
  source = "./modules/compute"
  compartment_ocid = module.dev_compartment.compartment_ocid
  tenancy_ocid = var.tenancy_ocid
  subnet_ocid = module.dev_subnets.public_subnet_ocid
  availability_domain = var.availability_domain
  region = var.region
  instance_image_ocid = local.oracle_linux_7[var.region]

  ssh_public_key = var.ssh_public_key
  instance_shape = "VM.Standard2.2"
  compute_display_name = "SFTP Development"
  instance__boot_volume_size = "50"
}

module "script_dev" {
  source = "./modules/compute"
  compartment_ocid = module.dev_compartment.compartment_ocid
  tenancy_ocid = var.tenancy_ocid
  subnet_ocid = module.dev_subnets.private_subnet_ocid
  availability_domain = var.availability_domain
  region = var.region
  instance_image_ocid = local.oracle_linux_7[var.region]

  ssh_public_key = var.ssh_public_key
  instance_shape = "VM.Standard2.2"
  compute_display_name = "Script Development"
  instance__boot_volume_size = "50"
}

module "object_storage_dev" {
  source = "./modules/objectstorage"
  compartment_ocid = module.dev_compartment.compartment_ocid
  bucket_name = "Dev_ObjStr" 
  bucket_access_type = "NoPublicAccess"
  bucket_storage_tier = "Standard"
}

module "file_storage_dev" {
  source = "./modules/file_storage"
  compartment_ocid = module.dev_compartment.compartment_ocid
  tenancy_ocid = var.tenancy_ocid
  subnet_ocid = module.dev_subnets.private_subnet_ocid
  availability_domain = var.availability_domain
  export_path = "/SBoxFS"

  mount_target_display_name = "MTScriptsServer"
  file_system_display_name = "SBoxFS"
}

# module "database_dev" {
#   source = "./modules/database"
#   availability_domain = var.availability_domain 
#   tenancy_ocid = var.tenancy_ocid
#   compartment_ocid = module.dev_compartment.compartment_ocid

#   subnet_ocid = module.dev_subnets.private_subnet_ocid
#   db_display_name = "testdb" //db sysytem display name
#   db_shape = "VM.Standard2.2"
#   db_node_count = "1"
#   db_ssh_public_keys = [var.ssh_public_key]
#   db_data_storage_size_in_gb = "256"
  

#   db_home_display_name = "homedb" 
#   db_hostname = "test" 
#   db_home_name = "testDB"
#   db_pdb_name = "pdb1"
#   db_home_admin_password = var.db_admin_password
# }

