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
provider.tf
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

## Step 0: Configuring the Provider

Don't forget to configure your `terraform.tfvars` file beforehand!

In this step we will set up our `provider.tf` file to allow us to authenticate into OCI. If we did not have this file, then we would have to run our authentication code for every module we run. This way, we only need to authenticate once. Read the `provider.tf` [file](provider.tf) for a better idea on how to format it. For more information, click [here](https://www.terraform.io/docs/configuration/providers.html) (Note: this link uses AWS in their examples).

## Step 1: Creating the VCN

Our code for creating a VCN and subnet was adapted using the template found [here](https://gist.github.com/lucassrg/9b97fb224cb4882d7db6b04a5b048ea8). We open port 80, 3000, 5000, and 1521 because the web application we would migrate use them.

In `main.tf` we pass the variables `user_ocid`, `tenancy_ocid`, `compartment_ocid`, `ssh_public_key_path`, `ssh_private_key_path`, `fingerprint`, `region`, and `availability_domain`. 

***IMPORTANT:*** We have hard-coded our `region` variable as "ad-ashburn-1." If your tenancy is in, for example, "us-phoenix-1", then you must change the value of `region`. Furthermore, we have decided as a preference to zero-index our availability domains. For example AD-1 is mapped to 0, AD-2 to 1, and AD-2 to 2. Therefore, since we want to use AD-1, our `availability_domain` variable returns 0.

### A Brief Intro to Output Variables

In `modules/vcn` we also have an `outputs.tf` [file](/modules/vcn/outputs.tf). We are outputting a variable called `subnet_ocid` which we will use later when we compute an instance. This is very helpful, because without the ability to output variables, we would have to run the vcn module, pause to find OCID of the subnet we just created, manually pass it to our compute module, and then run the compute module. By outputting the variable, we can run modules one after another even if one module is dependent on another module. We can reference the `subnet_ocid` variable in `main.tf` as `modules.vcn.subnet_ocid`. We will use more output variables later in the tutorial. Read more about output variables [here](https://www.terraform.io/intro/getting-started/outputs.html)

## Step 2: Creating the Bucket

## Step 3: Creating the Custom Image

## Step 4: Exporting the Custom Image

We used the OCI CLI (command line interface) to export an image onto a bucket with this command:

`oci compute image export to-object --image-id [OCID of image] -ns [OCI namespace] -bn [bucket name] --name [name of new object]`



## Step 5: Migrating the Custom Image

## Step 6: Creating a Compute Instance
