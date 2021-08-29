<h1 align="center">
Packer</h1>
<p align="center">By Sanjeev Thiyagarajan</p>

## Overview

## Table of Contents

1. [AWS Configure](#aws-configure)
2. [Build AMI](#build-ami)
3. [Configure Provisioners](#configure-provisioners)
4. [Script Provisioner](#script-provisioner)
5. [File Provisioner](#file-provisioner)
6. [Multiple Provisioners](#multiple-provisioners)
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

example.json

```
{
  "builders": [
    {
      "type": "amazon-ebs",
      "profile": "default",
      "region": "us-west-1",
      "ami_name": "ubuntu-nginx",
      "source_ami": "ami-0d382e80be7ffdae5",
      "instance_type": "t2.micro",
      "ssh_username": "ubuntu"
    }
  ]
}
```

```
packer build example.json
```

note: Be sure to deregister the AMI to delete it.

## Configure Provisioners

```
"provisioners": [
    {
      "type": "shell",
      "inline": [
        # sleep for 30 seconds to boot up fully before next line
        "sleep 30",
        "sudo apt update",
        "sudo apt install nginx -y"
      ]
    }
  ]
```

To confirm nginx is installed, ssh into the instance

```
systemctl status nginx
```

## Script Provisioner

## File Provisioner

## Multiple Provisioners

## Post Processors

## User-Variables

## Environment-Variables
