<h1 align="center">
Terraform Azure
</h1>
<p align="center">By Abraham Choi</p>

1. [Create VPC](#create-vpc)
2. [Create Internet Gateway](#create-internet-gateway)
3. [Create Route Table](#create-route-table)
4. [Create Subnet](#create-subnet)
5. [Associate Subnet And Route Table](#associate-subnet-and-route-table)
6. [Create Security Group](#create-security-group)
7. [Create Network Interface](#create-network-interface)
8. [Assign Elestic IP](#assign-elastic-ip)
9. [Create Ubuntu Server](#create-ubuntu-server)


## Create Provider
```
# Do not hardcode access and secret key into this file!
provider "aws" {
  region = "us-west-1"
  access_key = ""
  secret_key = ""
}
```

## Create VPC
Virtual Private Cloud (VPC) - A virtual network dedicated to your AWS account.

```
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}
```


## Create Internet Gateway
Internet Gateway - A gateway that you attach to your VPC to enable communication between resources in your VPC and the internet.

```
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}
```

## Create Route Table
Route Table - A set of rules, called routes, that are used to determine where network traffic is directed.

```
resource "aws_route_table" "prod_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
```

## Create Subnet
Subnet - A range of IP addresses in your VPC.

```
resource "aws_subnet" "subnet_1" {
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "prod-subnet"
  }
}
```


## Associate Subnet And Route Table

```
resource "aws_route_table_association" "prod-association" {
  subnet_id = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.prod_route_table.id
}
```

## Create Security Group

```
# Open ports: 22, 80, 443
resource "aws_security_group" "allow_web" {

  name = "allow_web"
  description = "Allow web traffic ports: 22, 80, 443"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    description = "HTTPS"
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-web"
  }
}

```

## Create Network Interface
Network Interface - A logical networking component in a VPC that represents a virtual network card.

```
# Use an IP address in the subnet
resource "aws_network_interface" "prod_nic" {
  subnet_id = aws_subnet.subnet_1.id
  private_ips = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}
```

## Assign Elestic IP

```
Associate elastic IP with the network interface
resource "aws_eip" "one" {
  vpc = true
  network_interface = aws_network_interface.prod-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.igw]
}
```

## Create Ubuntu Server

```
resource "aws_instance" "prod-instance" {
  ami = "ami-0d382e80be7ffdae5"
  instance_type = "t2.micro"
  availability_zone = "us-west-1b"
  key_name = main-key

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.prod-nic.id
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo your very first web server!' > /var/www/html/index.html
              EOF

  tags = {
    Name = "prod-instance"
  }
}
```