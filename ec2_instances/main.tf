provider "aws" {
  region  = "us-east-2"
  version = "~> 2.60"
}

resource "aws_key_pair" "lt-demo" {
  key_name   = "lt-demo"
  public_key = file("id_rsa.pub")
}

resource "aws_instance" "lt-instance" {
  count         = var.instance_count
  ami           = lookup(var.ami,var.aws_region)
  instance_type = var.instance_type
  key_name      = aws_key_pair.lt-demo.key_name

  vpc_security_group_ids = [aws_security_group.lt_sg_01.id]

tags = {
    Name  = "U-R-0${count.index + 1}"
    Batch = "5AM"
  }

}

resource "aws_security_group" "lt_sg_01" {

  name   = "U_R_01_sg"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_vpc" "default" {
  cidr_block = "10.1.0.0/16"
}

#resource "aws_nat_gateway" "default" {
#  subnet_id = aws_subnet.public.id
#}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = aws_vpc.default.cidr_block
}

#Adding Elastic IP for NAT gateway

resource "aws_eip" "test_eip" {
  vpc = true
}

#Adding NAT Gateway

resource "aws_nat_gateway" "test_nat_gw" {
  allocation_id = aws_eip.test_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "gw NAT"
  }
}

output "public_ip_addresses" {
  value = "${aws_instance.lt-instance.*.public_ip}"
}

output "public_DNS" {
  value = "${aws_instance.lt-instance.*.public_dns}"
}

output "privat_ip_addresses" {
  value = "${aws_instance.lt-instance.*.private_ip}"
}

