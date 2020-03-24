
/*
 * This example file shows how to configure the oci provider to target the a single region.
 */

// These variables would commonly be defined as environment variables or sourced in a .env file


provider "oci" {
  version          = ">= 3.0.0"
  region           = "${var.region}"
  tenancy_ocid     = "${var.tenancy_ocid}"
  user_ocid        = "${var.user_ocid}"
  fingerprint      = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  private_key_password = "${var.private_key_password}"
}
