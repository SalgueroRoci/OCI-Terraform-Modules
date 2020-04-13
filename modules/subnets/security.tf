
resource "oci_core_security_list" "private_security_list" {
  compartment_id    = var.compartment_ocid
  display_name      = "${var.prefix}-seclist-private"
  vcn_id            = var.vcn_ocid 

  egress_security_rules {
    protocol    = local.all_protocols
    destination = local.anywhere
  }

  ingress_security_rules {
    # allow ssh
    protocol = local.tcp_protocol
    source   = var.vcn_cidr_block

    tcp_options {
      min = local.ssh_port
      max = local.ssh_port
    }
  }

   ingress_security_rules {
        # allow ssh
        protocol = local.tcp_protocol
        source   = var.vcn_cidr_block

        tcp_options {
        min = local.oracle_db_port
        max = local.oracle_db_port
        }
    }
    
  ingress_security_rules {
    protocol  = local.icmp_protocol
    source    = local.anywhere
    stateless = true

    icmp_options {
      type = 3
      code = 4
    }
  }

   // allow inbound icmp traffic of ping
  ingress_security_rules {
    protocol  = local.icmp_protocol
    source    = local.anywhere
    stateless = true

    icmp_options {
      type = 0
    }
  }
  // allow inbound icmp traffic of ping
  ingress_security_rules {
    protocol  = local.icmp_protocol
    source    = local.anywhere
    stateless = true

    icmp_options {
      type = 8
    }
  }
  
}


resource "oci_core_security_list" "public_security_list" {
  compartment_id    = var.compartment_ocid
  display_name      = "${var.prefix}-seclist-public"
  vcn_id            = var.vcn_ocid 

  egress_security_rules {
    protocol    = local.all_protocols
    destination = local.anywhere
  }

  ingress_security_rules {
    # allow ssh
    protocol = local.tcp_protocol
    source   = local.anywhere

    tcp_options {
      min = local.ssh_port
      max = local.ssh_port
    }
  }

  ingress_security_rules {
    # allow ssh
    protocol = local.tcp_protocol
    source   = local.anywhere

    tcp_options {
      min = local.http_port
      max = local.http_port
    }
  }

  ingress_security_rules {
    # allow ssh
    protocol = local.tcp_protocol
    source   = local.anywhere

    tcp_options {
      min = local.https_port
      max = local.https_port
    }
  }

  ingress_security_rules {
    # allow ssh
    protocol = local.tcp_protocol
    source   = local.anywhere

    tcp_options {
      min = local.edq_port
      max = local.edq_port
    }
  }

  ingress_security_rules {
    # allow ssh
    protocol = local.tcp_protocol
    source   = local.anywhere

    tcp_options {
      min = local.JMX_port
      max = local.JMX_port
    }
  }

  ingress_security_rules {
    protocol  = local.icmp_protocol
    source    = local.anywhere
    stateless = true

    icmp_options {
      type = 3
      code = 4
    }
  }

   // allow inbound icmp traffic of ping
  ingress_security_rules {
    protocol  = local.icmp_protocol
    source    = local.anywhere
    stateless = true

    icmp_options {
      type = 0
    }
  }
  // allow inbound icmp traffic of ping
  ingress_security_rules {
    protocol  = local.icmp_protocol
    source    = local.anywhere
    stateless = true

    icmp_options {
      type = 8
    }
  }
  
}
