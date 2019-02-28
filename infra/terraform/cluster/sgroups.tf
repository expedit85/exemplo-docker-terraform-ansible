
# Cria um Security Group associado à VPC padrão
resource "aws_security_group" "public" {
  name = "PublicSG"
  description = "HTTP+SSH IN / Any OUT"

  tags {
    Name = "PublicSG"
  }

  ingress {     # HTTP IN
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {     # SSH IN
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {     # Alt SSH IN
    from_port   = "${var.alt_ssh_port}"
    to_port     = "${var.alt_ssh_port}"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {      # ANY OUT
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
