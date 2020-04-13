
variable compartment_ocid {} 
variable subnet_ocid {} 
variable availability_domain {} 
variable export_path {}
variable mount_target_display_name {}
variable file_system_display_name {}
variable tenancy_ocid {}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

resource "oci_file_storage_file_system" "TFfile_system" {
    #Required
    availability_domain = lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain],"name")
    compartment_id = var.compartment_ocid
    display_name = var.file_system_display_name
}

resource "oci_file_storage_mount_target" "TFmount_target" {
    #Required
    availability_domain = lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain],"name")
    compartment_id = var.compartment_ocid
    subnet_id = var.subnet_ocid 
    display_name = var.mount_target_display_name
}

resource "oci_file_storage_export_set" "TFexport_set" {
    #Required
    mount_target_id = oci_file_storage_mount_target.TFmount_target.id
}

resource "oci_file_storage_export" "TFexport" {
    #Required
    export_set_id = oci_file_storage_export_set.TFexport_set.id
    file_system_id = oci_file_storage_file_system.TFfile_system.id
    path = var.export_path
}

