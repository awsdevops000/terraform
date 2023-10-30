# terraform

# What is Terraform?
Terraform is an infrastructure as code tool that lets you build, change, and version cloud and on-prem resources safely and efficiently
{HashiCorp Terraform is an infrastructure as code tool that lets you define both cloud and on-prem resources in human-readable configuration files that you can version, reuse, and share. You can then use a consistent workflow to provision and manage all of your infrastructure throughout its lifecycle. Terraform can manage low-level components like compute, storage, and networking resources, as well as high-level components like DNS entries and SaaS features.
}

# Difference between terraform and ansible

Terraform provides a mechanism to manage the status of infrastructure resources and handles the whole lifecycle of those resources, from creation to deletion. Ansible focuses on configuring and maintaining already-existing systems rather than managing the entire lifecycle.

# Install Terraform

https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

# Terraform AWS Provider link 
https://registry.terraform.io/providers/hashicorp/aws/latest/docs

Create a file 

Main.tf
  
Aws configure —profile new 
   Provide the access key 
   Provide the secret key 

Provider “aws” {
  Region = “us-east-1”
  Profile = “new”
}

resource "aws_instance" "web" {
  ami = “ami provide” 
  instance_type = "t2.micro"
}

We need to init the file 
terraform init
Ls .terraform
Terraform plan (use to plan the resources)
Terraform apply (to apply the file)
Enter a value = yes (to approve)


 
+ create 
~ modified 
- delete

resource "aws_instance" "web" {
  ami = “ami provide” 
  instance_type = "t2.micro"
  Key_name = “mmm”
}

Terraform init
Terraform plan 
Terraform apply —auto-approve 


H.w 
Create 5 aws user with terraform 
Add all users to group cdecb12 
Create 5 s3 buckets








#Docker _ nginx in terraform

https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs


docker install krna jauri h 
sudo chown $USER /var/run/docker.sock -----> ya command sa sudo lana ki jurt nhi hogi

touch main.tf

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {}

# Pulls the image
resource "docker_image" "nginx" {
  name = "nginx:latest"
  keep_locally = false
}

# Create a container
resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "nginx-tf"
  ports {
    internal = 80
    external = 8080
  }
}
