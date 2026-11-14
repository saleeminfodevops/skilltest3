variable "aws_region" {
  description = "AWS region where resources will be provisioned"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type (Free Tier eligible)"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "Terraform-Ubuntu26-Nginx"
}

variable "sg_name" {
  description = "Name for the security group"
  type        = string
  default     = "terraform-nginx-ubuntu26-sg"
}

variable "public_key_path" {
  description = "Path to the local SSH public key for EC2 access"
  type        = string
  default     = "~/.ssh/terraform-aws-key.pub"
}

variable "html_content" {
  description = "Custom HTML content for the Nginx index page"
  type        = string
  default     = "<h1>Welcome to the Terraform-managed Nginx Server on Ubuntu</h1>"
}

