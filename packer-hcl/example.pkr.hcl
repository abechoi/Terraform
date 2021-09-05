
source "amazon-ebs" "aws_src" {
  ami_name      = "ubuntu-nginx 1.0"
  instance_type = "t2.micro"
  profile       = "default"
  region        = "us-west-1"
  source_ami    = "ami-0d382e80be7ffdae5"
  ssh_username  = "ubuntu"
}

source "azure-arm" "azure_src" {
  client_id                         = "XXXX"
  client_secret                     = "XXXX"
  image_offer                       = "UbuntuServer"
  image_publisher                   = "Canonical"
  image_sku                         = "18.04-LTS"
  location                          = "West US"
  managed_image_name                = "ubuntu-nginx"
  managed_image_resource_group_name = "RG-1"
  os_type                           = "Linux"
  subscription_id                   = "XXXX"
  tenant_id                         = "XXXX"
}

build {
  sources = ["source.amazon-ebs.aws_src", "source.azure-arm.azure_src"]

  provisioner "shell" {
    script = "script.sh"
  }

  provisioner "file" {
    destination = "/tmp/"
    source      = "index.html"
  }

  provisioner "shell" {
    inline = ["sudo cp /tmp/index.html /var/www/html/"]
  }

  post-processor "manifest" {
    output = "output.json"
  }
  post-processor "vagrant" {
  }
}
