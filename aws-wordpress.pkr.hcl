packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
      }
    }
  }
 source "amazon-ebs" "basic-ami" {
  ami_name = "wordpress-ami"
  instance_type = "t3a.micro"
  ssh_username  =  "ubuntu"
  source_ami = "ami-0d70546e43a941d70"
  region         = "us-west-2"
}
build {
  sources = ["source.amazon-ebs.basic-ami"]
  provisioner "shell" {
    script       = "WordpressInstall.sh"
    pause_before = "10s"
    timeout      = "10s"
}
  provisioner "file" {
  source = "wordpress.conf"
  destination = "/tmp/wordpress.conf"  
}
  provisioner "shell" {
    inline = ["sudo cp /tmp/wordpress.conf /etc/nginx/sites-available/",
    "sudo ln -s /etc/nginx/sites-available/your_domain /etc/nginx/sites-enabled/",
    "sudo unlink /etc/nginx/sites-enabled/default"]
}
    }