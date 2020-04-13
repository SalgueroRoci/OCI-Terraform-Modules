# Terraform OCI Provider

Terraform module template for OCI provider. Example for creating VCN, compute, and block.
Terraform OCI provider was updated to 3.0.0.
Terraform v0.12.24

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
compartment_ocid = [OCID of the destination compartment] 
db_admin_password = "WElcome#123#"
```

These values are passed onto `vars.tf` and is mainly used in `main.tf`.

Also, this walkthrough requires the installation of the OCI CLI. Please have that installed before continuing.

## Terraform Structure

We split our Terraform project into modules, which can be thought of as smaller Terraform functions. A module will be in its own separate folder in the `modules` directory.

```
main.tf
vars.tf
provider.tf
terraform.tfvars
modules
 |
 |---- compartment
 |---- vcn  
 |---- compute
 |---- objectstorage
 |---- file_storage
 |---- database

```

In `main.tf` we run each module sequentially, starting with the `vcn` module, and ending with the `compute` module. Here is a brief description of what each module does.

`vcn` - Creates a new virtual cloud network, internet gateway, and a subnet with a security list

`compute` - Create a new instance. 

## Step 0: Configuring the Provider and Main File

Don't forget to configure your `terraform.tfvars` file beforehand!

In this step we will set up our `provider.tf` file to allow us to authenticate into OCI. If we did not have this file, then we would have to run our authentication code for every module we run. This way, we only need to authenticate once. Read the `provider.tf` [file](provider.tf) for a better idea on how to format it. For more information, click [here](https://www.terraform.io/docs/configuration/providers.html) (Note: this link uses AWS in their examples).

Our `main.tf` [file](main.tf) is what we will use to run all our modules. Every time we want to add a module we use this block:

```
module "module_name_1" {
  source = [insert path to folder of module]
  example_variable_1 = var.example_variable_1
  example_variable_2 = "hard coded variable"
  example_variable_3 = module.example_module.example_output_variable
}
```
In this code we set a path to the module and pass in variables the module requires. These variables should be set beforehand `vars.tf` and `terraform.tfvars` (especially if they are sensitive) but you can also hard code them like in `example_variable_2`. There is an example of how to pass in external variables outputted by a module in `example_variable_3`. We will get to that later.

To initialize the Terraform project, call `terraform init` on your command line. To see how the project would change your OCI infrastructure call `terraform plan`. To apply these changes, run `terraform apply`


## Step 1: Creating the VCN

Our code for creating a VCN and subnet was adapted using the template found [here](https://gist.github.com/lucassrg/9b97fb224cb4882d7db6b04a5b048ea8). We open port 80, 3000, 5000, and 1521 because our web application we would migrate needs them. 

In `main.tf` we pass the variables `user_ocid`, `tenancy_ocid`, `compartment_ocid`, `ssh_public_key_path`, `ssh_private_key_path`, `fingerprint`, `region`, and `availability_domain`. 

***IMPORTANT:*** We have hard-coded our `region` variable as "ad-ashburn-1." If your tenancy is in, for example, "us-phoenix-1", then you must change the value of `region`. Furthermore, we have decided as a preference to zero-index our availability domains. For example AD-1 is mapped to 0, AD-2 to 1, and AD-2 to 2. Therefore, since we want to use AD-1, our `availability_domain` variable returns 0.

### A Brief Intro to Output Variables

In `modules/vcn` we also have an `outputs.tf` [file](/modules/vcn/outputs.tf). We are outputting a variable called `subnet_ocid` which we will use later when we compute an instance. This is very helpful, because without the ability to output variables, we would have to run the vcn module, pause to find OCID of the subnet we just created, manually pass it to our compute module, and then run the compute module. By outputting the variable, we can run modules one after another even if one module is dependent on another module. Terraform will understand there is an implicit dependency between those modules (you cannot yet state explicit dependencies between module). We can reference the `subnet_ocid` variable in `main.tf` as `modules.vcn.subnet_ocid`. We will use more output variables later in the tutorial. Read more about output variables [here](https://www.terraform.io/intro/getting-started/outputs.html)

Also learn more about dependencies [here](https://www.terraform.io/intro/getting-started/dependencies.html). They're also important to know!

## Step 2: Creating a Compute Instance

Finally, we create the compute mostly using code from Abhiram Ampabathina [here](https://github.com/mrabhiram/terraform-oci-sample/tree/master/modules/compute-instance) (we barely wrote any original code as you can probably tell, but we never really tread any new ground that required new code. As long as you have a good understanding of Terraform, we believe it's okay. And even if you don't, looking at example code is a good way to learn ☺️).

## Conclusion
It has been made clear through this lab how powerful and useful Terraform is for DevOps and cloud developers. We hope this walkthrough was useful!
