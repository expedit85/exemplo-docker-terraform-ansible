
# Exporta IPs público das instâncias criadas
# terraform show / terraform output public_ip
output "public_ip" {
    value = "${aws_instance.sample.public_ip}"
}


# Exporta CIDR da subrede na VPC
output "subnet" {
  value = "${aws_default_subnet.default_az1.cidr_block}"
}


# Exporta caminho para arquivo com chave privada do SSH
output "private_key_file" {
  value = "${local.private_key_file}"
}


# Exporta o número de porta SSH do servidor
output "ssh_port" {
  value = "${var.alt_ssh_port}"
}
