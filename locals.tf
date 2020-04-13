locals {
  oracle_linux_7 = {
    // See https://docs.us-phoenix-1.oraclecloud.com/images/
    // Oracle-provided image "Oracle-Linux-7.5-2018.10.16-0"
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaa6hooptnlbfwr5lwemqjbu3uqidntrlhnt45yihfj222zahe7p3wq"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaa6tp7lhyrcokdtf7vrbmxyp2pctgg4uxvt4jz4vc47qoc2ec4anha"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaadvi77prh3vjijhwe5xbd6kjg3n5ndxjcpod6om6qaiqeu3csof7a"
    uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaaw5gvriwzjhzt2tnylrfnpanz5ndztyrv3zpwhlzxdbkqsjfkwxaq"
  }

  cent_os_7 = {
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaaoalijbjpvkc4sidrhnfqjglzazeuihvabdz3bzm4knwad37zmebq"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaa5bendugawh7ver3akaxd3ods5k4fnszp3casvho5kyu3bet7oigq"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa6zpubgqnm3j46smrd7fjehmmj3emusyfljypxcwzrmlcnuno7gra"
    uk-london-1    = "ocid1.image.oc4.uk-gov-london-1.aaaaaaaaznmvmboviq4volpaomwe6ekgcyqcevgx2qvcjgyyedwm75vfn2pa"
  }
  edq_image = lookup(data.oci_core_app_catalog_subscriptions.test_app_catalog_subscriptions.app_catalog_subscriptions[0], "listing_resource_id")
}
 
# Following is used to agree to terms of service for market place images. To see a list uncomment the output below
# output "marketplace" {
#   value = data.oci_core_app_catalog_listings.test_app_catalog_listings
# }

data "oci_core_app_catalog_listings" "test_app_catalog_listings" {
  filter {
    name   = "display_name"
    values = ["Oracle Enterprise Data Quality on Tomcat"]
  }
}

data "oci_core_app_catalog_listing_resource_versions" "test_app_catalog_listing_resource_versions" {
  #Required
  listing_id = lookup(data.oci_core_app_catalog_listings.test_app_catalog_listings.app_catalog_listings[0],"listing_id")
}

resource "oci_core_app_catalog_listing_resource_version_agreement" "test_app_catalog_listing_resource_version_agreement" {
  #Required
  listing_id               = lookup(data.oci_core_app_catalog_listing_resource_versions.test_app_catalog_listing_resource_versions.app_catalog_listing_resource_versions[0], "listing_id")
  listing_resource_version = lookup(data.oci_core_app_catalog_listing_resource_versions.test_app_catalog_listing_resource_versions.app_catalog_listing_resource_versions[0], "listing_resource_version")
}

resource "oci_core_app_catalog_subscription" "test_app_catalog_subscription" {
  compartment_id           = var.compartment_ocid
  eula_link                = oci_core_app_catalog_listing_resource_version_agreement.test_app_catalog_listing_resource_version_agreement.eula_link
  listing_id               = oci_core_app_catalog_listing_resource_version_agreement.test_app_catalog_listing_resource_version_agreement.listing_id
  listing_resource_version = oci_core_app_catalog_listing_resource_version_agreement.test_app_catalog_listing_resource_version_agreement.listing_resource_version
  oracle_terms_of_use_link = oci_core_app_catalog_listing_resource_version_agreement.test_app_catalog_listing_resource_version_agreement.oracle_terms_of_use_link
  signature                = oci_core_app_catalog_listing_resource_version_agreement.test_app_catalog_listing_resource_version_agreement.signature
  time_retrieved           = oci_core_app_catalog_listing_resource_version_agreement.test_app_catalog_listing_resource_version_agreement.time_retrieved

  timeouts {
    create = "20m"
  }
}

# source_id   = "${lookup(data.oci_core_app_catalog_subscriptions.test_app_catalog_subscriptions.app_catalog_subscriptions[0], "listing_resource_id")}"
data "oci_core_app_catalog_subscriptions" "test_app_catalog_subscriptions" {
  #Required
  compartment_id = var.compartment_ocid

  #Optional
  listing_id = oci_core_app_catalog_subscription.test_app_catalog_subscription.listing_id

  filter {
    name   = "listing_resource_version"
    values = [oci_core_app_catalog_subscription.test_app_catalog_subscription.listing_resource_version]
  }
} 