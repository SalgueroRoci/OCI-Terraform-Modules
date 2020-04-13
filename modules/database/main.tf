variable availability_domain {} 
variable compartment_ocid {}
variable tenancy_ocid {}

variable subnet_ocid {}
variable db_display_name {} 
variable db_hostname {}
variable db_shape {}
variable db_node_count {} 
variable db_ssh_public_keys {}
variable db_data_storage_size_in_gb {} 

variable db_home_admin_password {}
variable db_home_display_name {}
variable db_home_name {}
variable db_pdb_name {}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

data "oci_database_db_versions" "TFdb_versions" {
    #Required
    compartment_id = var.compartment_ocid
} 

resource "oci_database_db_system" "TFDatabaseSystem" {
    #Required
    availability_domain = lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain],"name")
    compartment_id = var.compartment_ocid
    
    subnet_id = var.subnet_ocid
    display_name = var.db_display_name 
    hostname = var.db_hostname
    shape = var.db_shape
    node_count = var.db_node_count 
    ssh_public_keys = var.db_ssh_public_keys
    data_storage_size_in_gb = var.db_data_storage_size_in_gb 
    
    domain = var.db_hostname
    database_edition = "ENTERPRISE_EDITION"
    license_model = "LICENSE_INCLUDED"
    time_zone = "UTC"

    db_home {
        
        #Optional
        db_version = data.oci_database_db_versions.TFdb_versions.db_versions[2].version
        display_name = var.db_home_display_name
        
        #Required
        database {
            #Required
            admin_password = var.db_home_admin_password

            db_name = var.db_home_name 
            pdb_name = var.db_pdb_name
            
        }

    }
    
}