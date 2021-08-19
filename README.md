<h1 align="center">
Terraform Projects
</h1>
<p align="center">By Abraham Choi</p>

1. [AWS CLI](#aws-cli)
2. [Azure CLI](#azure-cli)
3. [Terraform AWS](#terraform-aws)
4. [Terraform Azure](#terraform-azure)


## AWS CLI
Tutorial by Sanjeev Thiyagarajan, that utilizes aws configure to create ~/.aws/configure and ~/.aws/credentials. This course covers create, delete, and describe functions for key pairs, instances, and S3 buckets.

## Azure CLI
Tutorial by Sanjeev Thiyagarajan.

## Terraform AWS
Tutorial by Sanjeev Thiyagarajan, that covers a wide array of Terraform topics, from getting started and authenticating, to creating and destorying resources. To run main.tf, you will need to change the shared_credentials_file field in the provider block with an aws credentials file of your own. If not, you'll have to create one using AWS CLI, aws configure command. Else, you may replace the shared_credentials_file with access_key and secret_key, which can be found in your AWS console.

note: you may also have to change other fields, such as region, availability_zone, ami, and key_name.

## Terraform Azure
In the near future, by utilizing offical docs and any available resources, I want to mimic everything I've covered in Terraform AWS for Azure...