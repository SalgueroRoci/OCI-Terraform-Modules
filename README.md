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

These values are passed onto `vars.tf` and is mainly used in `main.tf`.

## Terraform Structure

We split our Terraform project into modules, which can be thought of as smaller Terraform functions. A module will be in its own separate folder in the `modules` directory.

```
main.tf
vars.tf
terraform.tfvars
modules
 |
 |---- vcn
 |---- bucket
 |---- create_image
 |---- migrate_image
 |---- compute

```

In `main.tf` we run each module sequentially, starting with the `vcn` module, and ending with the `compute` module. Here is a brief description of what each module does.

`vcn` - Creates a new virtual cloud network, internet gateway, and a subnet with a security list

`bucket` - Creates a new object storage bucket to later migrate an image into

`create_image` - Creates a new custom image with the provided image OCID and in the respective compartment

`migrate_image` - Migrate the created custom image from a bucket onto the source compartment

`compute` - Create a new instance with the recently migrated image.

## Step 1: Creating the VCN

## Step 2: Creating the Bucket

## Step 3: Creating the Custom Image

## Step 4: Exporting the Custom Image

## Step 5: Migrating the Custom Image

## Step 6: Creating a Compute Instance
