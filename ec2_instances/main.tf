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

  name = "U_R_01_sg"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip_addresses" {
  value = "${aws_instance.lt-instance.*.public_ip}"
}

output "public_DNS" {
  value = "${aws_instance.lt-instance.*.public_dns}"
}

