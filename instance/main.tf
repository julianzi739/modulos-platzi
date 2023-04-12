provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "ssh_conection" {
  name = var.sg_name

  #   ingress {
  #     description      = "TLS from VPC"
  #     from_port        = 443
  #     to_port          = 443
  #     protocol         = "-1"
  #     cidr_blocks      = [aws_vpc.main.cidr_block]
  #     ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  #   }

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "platzi-instance" {
  #ami           = "ami-06e46074ae430fba6"
  ami             = var.ami_id
  instance_type   = var.instance_type
  tags            = var.tags
  security_groups = ["${aws_security_group.ssh_conection.name}"]
}

