<h1 align="center">
Terraform Projects
</h1>
<p align="center">By Abraham Choi</p>

1. [AWS CLI](#aws-cli)
2. [Azure CLI](#azure-cli)
3. [Packer JSON](#packer-json)
4. [Packer HCL](#packer-hcl)
5. [Terraform AWS](#terraform-aws)
6. [Terraform Azure](#terraform-azure)

## [AWS CLI](https://github.com/abechoi/Terraform/tree/main/aws-cli)

Tutorial by Sanjeev Thiyagarajan, that utilizes aws configure to create ~/.aws/configure and ~/.aws/credentials. This course covers create, delete, and describe functions for key pairs, instances, and S3 buckets.

## [Azure CLI](https://github.com/abechoi/Terraform/tree/main/azure-cli)

Tutorial by Sanjeev Thiyagarajan, that utilizes az login to authenticate the terraform file. This course covers create, delete, and list functions for resource groups and virtual machines.

## [Packer JSON](https://github.com/abechoi/Terraform/tree/main/packer-json)

Tutorial by Sanjeev Thiyagarajan, that covers the fundamentals of Packer using JSON, from authenticating, to creating custom images for AWS and Azure. To run example.json, you may have to change fields, such as profile, region, and other fields related to credentials.

## [Packer HCL](https://github.com/abechoi/Terraform/tree/main/packer-hcl)

Using offical documentation, combined with what I've learned in the Packer JSON tutorial, I would like to create a similar packer file using HCL instead of JSON.

## [Terraform AWS](https://github.com/abechoi/Terraform/tree/main/terraform-aws)

Tutorial by Sanjeev Thiyagarajan, that covers a wide array of Terraform topics, from getting started and authenticating, to creating and destorying resources. To run main.tf, you may have to change some fields, such as region, availability_zone, ami, and key_name.

## [Terraform Azure](https://github.com/abechoi/Terraform/tree/main/terraform-azure)

Using official documentation, I was able to create a similar main.tf for Azure, as I have with AWS. There were a few minor differences, but it was more of the same. I still have yet to figure out how to input a user_data script for azurerm_linux_virtual_machines, like I can with aws_instance.
