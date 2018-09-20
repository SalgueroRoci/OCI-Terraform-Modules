# IaaSathon 2 Walkthrough

In this lab, we were tasked to migrate a custom image from one compartment to another through Terraform and the OCI (Oracle Cloud Infrastructure) CLI.

## Before We Begin

We need to create a file called `terraform.tfvars`. This file will contain sensitive information used to authenticate ourselves to the OCI.

```
//terraform.tfvars

user_ocid = [OCID of the OCI user. We used api.user]
tenancy_ocid = [OCID of the tenancy]
fingerprint = [Fingerprint of OCI public key added to user]
private_key_path= [Path to OCI private key file]
ssh_public_key_path = [Path to public ssh key]
ssh_private_key_path = [Path to private ssh key]
ssh_public_key = [Public key]
region = [Region of tenancy]
customer_compartment_ocid = [OCID of the source compartment]
cloud_compartment_ocid = [OCID of the destination compartment]
instance_ocid = [OCID of the instance to create a custom image of and then migrate]
```

