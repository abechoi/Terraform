<h1 align="center">
Packer</h1>
<h2 align="center">
Using HCL</h2>
<p align="center">By Abraham Choi</p>

## Overview

This tutorial covers the fundamentals of Packer using HCL. To run it, use command: packer build example.pkr.hcl, make sure to replace AWS and Azure credentials and pick a region of your choosing. To run only one build, use the -only flag. ie. packer build -only=azure-arm example.pkr.hcl.

## Table of Contents

1. [AWS Configure](#aws-configure)
2. [Build AMI](#build-ami)
3. [Configure Provisioners](#configure-provisioners)
4. [Script Provisioner](#script-provisioner)
5. [File Provisioner](#file-provisioner)
6. [Build Azure Image](#build-azure-image)
7. [Post Processors](#post-processors)
8. [User-Variables](#user-variables)
9. [Environment-Variables](#environment-variables)

## AWS Configure

Create ~/.aws/credentials and ~/.aws/configure.

```
aws configure

# from the AWS console, go to user profile, My Security Credentials, Access Keys
# then Create New Access Key, Show Access Key

AWS Access Key ID [****************UENB]:
AWS Secret Access Key [****************J6pH]:
Default region name [us-west-2]: us-west-1
Default output format [None]: json
```

## Build AMI

example.pkr.hcl

```
source "amazon-ebs" "aws_src" {
  ami_name      = "ubuntu-nginx 1.0"
  instance_type = "t2.micro"
  profile       = "default"
  region        = "us-west-2"
  source_ami    = "ami-0d382e80be7ffdae5"
  ssh_username  = "ubuntu"
}
```

```
packer build example.pkr.hcl
```

note: Be sure to deregister the AMI to delete it.

## Configure Provisioners

```
provisioner "shell" {
  "inline": [
    "sleep 30",
    "sudo apt update",
    "sudo apt install nginx -y",
    "systemctl enable nginx",
    "sudo ufw allow ssh",
    "sudo ufw allow http",
    "sudo ufw allow https",
    "sudo ufw enable"
  ]
}
```

To confirm nginx is installed, ssh into the instance

```
systemctl status nginx
```

## Script Provisioner

Alternatively, instead of inserting all commands into inline, using script is available.

script.sh

```
sleep 30
sudo apt update
sudo apt install nginx -y
systemctl enable nginx
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw enable
```

example.pkr.hcl

```
"provisioners": [
    {
      "type": "shell",
      "script": "script.sh",

    }
  ]
```

## File Provisioner

Create an index.html, reference it in the file provisioner and put it in /tmp.

```
"provisioners": [
  {
    "type": "file",
    "source": "index.html",
    "destination": "/tmp/"
  },
  {
    "type": "shell",
    # shell provisioner may use sudo, now it's possible to move index.html into /var/www/html
    "inline": ["sudo cp /tmp/index.html /var/www/html/"]
  }
]
```

## Build Azure Image

1. Get the client_id

   Go to Active Directory > App registrations > New registration - Name the app and get the Application (client) ID.

2. Get the client_secret

   Go to Certificates & secrets > New client secret - Give a description and get the value.

3. Get the subscription_id

   Go to Subscriptions - Choose a subscription, Access control, Add role assignment, and create an owner role assigned to packer-test.

4. Create a Resource Group

```
# to list publishers for westus
az vm image list-publishers --location westus

# to list offers for westus
az vm image list-offers --location westus --publisher Canonical

# to list SKUs for westus
az vm image list-skus --location westus --publisher Canonical --offer UbuntuServer
```

example.pkr.hcl

```
"builders": [
    {
      "type": "amazon-ebs",
      "profile": "default",
      "region": "us-west-1",
      "ami_name": "ubuntu-nginx",
      "source_ami": "ami-0d382e80be7ffdae5",
      "instance_type": "t2.micro",
      "ssh_username": "ubuntu"
    },
    {
      "type": "azure-arm",
      "client_id": "XXXX",
      "client_secret": "XXXX",
      "tenant_id": "XXXX",
      "subscription_id": "XXXX",

      "image_publisher": "Canonical",
      "image_offer": "UbuntuServer",
      "image_sku": "18.04-LTS",

      "location": "West US",
      "os_type": "Linux",
      "managed_image_name": "ubuntu-nginx",
      "managed_image_resource_group_name": "RG-1"
    }
  ]
```

To only run azure-arm builder...

```
packer build -only=azure-arm
```

To create a file for variables...

variables.json

```
{
  "description": "ubuntu-nginx",
  "version": ""
}
```

Then run...

```
packer build -var-file=variables.json example.json
```

## Post Processors

Post Processors can perform certain tasks after a build is complete.

```
"post-processors": [
  {
    # outputs a manifest into a json format
    "type": "manifest",
    "output": "output.json"
  },
  {
    # create a vagrant box
    "type": "vagrant"
  }
]
```

## User-Variables

To create variables, declare variables within its own block, and call it using "{{user `VARIABLE_NAME`}}.

```
"variables": {
  "description": "ubuntu-nginx",
  "version": ""
},
"builders": [
  {
    "type": "amazon-ebs",
    "profile": "default",
    "region": "us-west-1",
    "ami_name": "{{user `description`}}--{{user `version`}}",
    "source_ami": "ami-0d382e80be7ffdae5",
    "instance_type": "t2.micro",
    "ssh_username": "ubuntu"
  }
],
"post-processors": [
  {
    "type": "manifest",
    "output": "{{user `description`}}.json"
  }
]
```

To declare variables from the command line...

```
# use single quotes for Mac/Linux, use double quotes for Windows
packer build -var 'description=ubuntu-nginx' example.json

# for 2 variables...
packer build -var 'description=ubuntu-nginx' -var 'version=2.4' example.json
```

## Environment-Variables

```
"variables": {
  "access_key": "{{env `ACCESS_KEY`}}",
  "secret_key": "{{env `SECRET_KEY`}}"
},
"builders": [
  {
    "type": "amazon-ebs",
    "access_key": "{{user `access_key`}}",
    "secret_key": "{{user `secret_key`}}",
    "region": "us-west-1",
    "ami_name": "{{user `description`}}--{{user `version`}}",
    "source_ami": "ami-0d382e80be7ffdae5",
    "instance_type": "t2.micro",
    "ssh_username": "ubuntu"
  }
]
```

To avoid private variables to show on Packer logs, use sensitive-variables

```
"sensitive-variables": [
  "access_key",
  "secret_key"
]
```
