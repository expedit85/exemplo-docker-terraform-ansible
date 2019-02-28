
locals {
   default_user_data = <<-EOF
            #!/bin/bash
            echo "configuring" > ${local.remote_ec2_state_file} &&
            sed -ri 's/^#?\s*Port [0-9]+\s*$/Port 22\nPort ${var.alt_ssh_port}/' /etc/ssh/sshd_config &&
            service ssh restart &&
            export DEBIAN_FRONTEND=noninteractive &&
            apt-get update  -y --fix-missing &&
            apt-get upgrade -y &&
            apt-get install -y --no-install-recommends python python3 &&
            echo "ready" > ${local.remote_ec2_state_file}
            EOF

    provisioner_command = <<-EOF
            SSH_PRIVATE_KEY="${local.private_key_file}" \
            REMOTE_HOST_STATE_FILE="${local.remote_ec2_state_file}" \
            SSH_PORT="${var.alt_ssh_port}" \
            ./scripts/configure-server.sh
            EOF
}



# Configuração de instância EC2 usando rede e subrede padrões
resource "aws_instance" "sample" {
    ami = "${var.ubuntu_ami}"
    instance_type = "t3.small"
    availability_zone = "${local.instance_az}"
    associate_public_ip_address = true
    vpc_security_group_ids = [ "${aws_security_group.public.id}" ]
    key_name = "${aws_key_pair.deployer.key_name}"

    tags {
        Name = "sample"
        SwarmRole = "manager"
    }

    # Aguarda instalação dos requisitos e executa playbook do ansible para configurar a nova instância EC2
    provisioner "local-exec" {
        command = "${local.provisioner_command}"
        environment = {
            SSH_HOST = "${self.public_ip}"
        }
    }

    # Instala requisitos para executar ansible
    user_data = "${local.default_user_data}"
}

