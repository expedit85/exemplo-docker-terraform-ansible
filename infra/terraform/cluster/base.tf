
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
  version    = "~> 1.60"
}


locals {
  # Guarda estado de execução dos comandos em "user_data"
  remote_ec2_state_file = "/var/run/ec2-instance-state"

  default_key_pair_name = "sample-key-pair"

  private_key_file = "keys/${local.default_key_pair_name}"

  instance_az = "${format("%sb", var.region)}"
}


# Chave SSH para acessar a instância EC2
resource "aws_key_pair" "deployer" {
  key_name   = "${local.default_key_pair_name}"
  public_key = "${file(format("%s.pub", local.private_key_file))}"
}


resource "aws_default_subnet" "default_az1" {
  availability_zone = "${local.instance_az}"
}
