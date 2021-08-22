<h1 align="center">
Terraform Projects
</h1>
<p align="center">By Abraham Choi</p>

1. [AWS CLI](#aws-cli)
2. [Azure CLI](#azure-cli)
3. [Packer](#packer)
4. [Terraform AWS](#terraform-aws)
5. [Terraform Azure](#terraform-azure)

## [AWS CLI](https://github.com/abechoi/Terraform/tree/main/aws-cli)

Tutorial by Sanjeev Thiyagarajan, that utilizes aws configure to create ~/.aws/configure and ~/.aws/credentials. This course covers create, delete, and describe functions for key pairs, instances, and S3 buckets.

## [Azure CLI](https://github.com/abechoi/Terraform/tree/main/azure-cli)

Tutorial by Sanjeev Thiyagarajan, that utilizes az login to authenticate the terraform file. This course covers create, delete, and list functions for resource groups and virtual machines.

## [Packer](https://github.com/abechoi/Terraform/tree/main/packer)

Tutorial by Sanjeev Thiyagarajan.

## [Terraform AWS](https://github.com/abechoi/Terraform/tree/main/terraform-aws)

Tutorial by Sanjeev Thiyagarajan, that covers a wide array of Terraform topics, from getting started and authenticating, to creating and destorying resources. To run main.tf, you will need to change the shared_credentials_file field in the provider block with an aws credentials file of your own. If not, you'll have to create one using AWS CLI, aws configure command. Else, you may replace the shared_credentials_file with access_key and secret_key, which can be found in your AWS console.

note: you may also have to change other fields, such as region, availability_zone, ami, and key_name.

## [Terraform Azure](https://github.com/abechoi/Terraform/tree/main/terraform-azure)

Using official documentation, I was able to create a similar main.tf for Azure as I have with AWS. There were a few minor differences, but it was more of the same. I still have yet to figure out how to input a user_data script for azurerm_linux_virtual_machines, like I can with aws_instance.
