# AWS credentials
variable "aws_access_key" {
  description = "the user's AWS access key"
}
variable "aws_secret_key" {
  description = "the user's AWS secret key"
}

# AWS region for DevOps VPC
variable "region" {
  description = "Default region where resources will be created"
}

variable "ubuntu_ami" {
  description = "Ubuntu Amazon Image"
}

variable "alt_ssh_port" {
  default = 4422
  description = "Alternate SSH port for EC2 instances"
}
