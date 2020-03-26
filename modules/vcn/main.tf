variable "compartment_ocid" {}
variable "availability_domain" {}
variable "region" {}
# prefix for all the resources
variable "prefix" {}
variable "vcn_cidr_block" {}
variable "pub_subnet_cidr_block" {}
variable "priv_subnet_cidr_block" {}

resource "oci_core_virtual_network" "vcn" {
  cidr_block     = "${var.vcn_cidr_block}"
  compartment_id = "${var.compartment_ocid}"
  display_name   = "${var.prefix}_VCN"
  dns_label      = "${var.prefix}_VCN"
}

resource "oci_core_internet_gateway" "ig" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "${var.prefix}-ig"
  vcn_id         = "${oci_core_virtual_network.vcn.id}"
}

resource "oci_core_route_table" "rt_public" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.vcn.id}"
  display_name   = "${var.prefix}-rt-public"

  route_rules {
    destination        = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.ig.id}"
  }
}

resource "oci_core_route_table" "rt_private" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.vcn.id}"
  display_name   = "${var.prefix}-rt-private"
}

resource "oci_core_subnet" "subnet_private" {
  display_name        = "${var.prefix}-subnet-private"
  cidr_block          = "${var.priv_subnet_cidr_block}"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.vcn.id}"

  route_table_id      = "${oci_core_route_table.rt_private.id}"
  security_list_ids   = ["${oci_core_security_list.private_security_list.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.vcn.default_dhcp_options_id}"
  dns_label           = "${var.prefix}priv"
}

resource "oci_core_subnet" "subnet_public" {
  display_name        = "${var.prefix}-subnet-public"
  cidr_block          = "${var.pub_subnet_cidr_block}"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.vcn.id}"

  route_table_id      = "${oci_core_route_table.rt_public.id}"
  security_list_ids   = ["${oci_core_security_list.public_security_list.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.vcn.default_dhcp_options_id}"
  dns_label           = "${var.prefix}pub"
}

resource "oci_core_security_list" "private_security_list" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.vcn.id}"
  display_name   = "private-security-list"

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "${var.vcn_cidr_block}"
    protocol    = "6" //tcp
  }

  // allow inbound ssh traffic
  ingress_security_rules {
    protocol  = "6"         // tcp
    source    = "${var.pub_subnet_cidr_block}"
    stateless = false

    tcp_options {
      "min" = 22
      "max" = 22
    }
  }

    // allow inbound database traffic
  ingress_security_rules {
    protocol  = "6"         // tcp
    source    = "${var.pub_subnet_cidr_block}"
    stateless = false

    tcp_options {
      "min" = 1521
      "max" = 1521
    }
  }

  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    protocol  = 1
    source    = "0.0.0.0/0"
    stateless = true

    icmp_options {
      "type" = 3
      "code" = 4
    }
  }
}

resource "oci_core_security_list" "public_security_list" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.vcn.id}"
  display_name   = "public-security-list"

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6" //tcp
  }


  # // allow inbound traffic to port weblogic (vnc)
  # ingress_security_rules {
  #   protocol  = "6"         // tcp
  #   source    = "0.0.0.0/0"
  #   stateless = false

  #   tcp_options {
  #     "min" = 000
  #     "max" = 000
  #   }
  # }

  // allow inbound ssh traffic
  ingress_security_rules {
    protocol  = "6"         // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      "min" = 22
      "max" = 22
    }
  }

  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    protocol  = 1
    source    = "0.0.0.0/0"
    stateless = false

    icmp_options {
      "type" = 3
      "code" = 4
    }
  }

  // allow inbound icmp traffic of ping
  ingress_security_rules {
    protocol  = 1
    source    = "0.0.0.0/0"
    stateless = false

    icmp_options {
      "type" = 0
    }
  }
  // allow inbound icmp traffic of ping
  ingress_security_rules {
    protocol  = 1
    source    = "0.0.0.0/0"
    stateless = false

    icmp_options {
      "type" = 8
    }
  }
}