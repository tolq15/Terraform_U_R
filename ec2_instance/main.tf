provider "aws" {
  region  = "us-east-2"
  version = "~> 2.60"
}

resource "aws_instance" "lt_ubuntu_01" {
  count         = 3
  ami           = "ami-07c1207a9d40bc3bd"
  instance_type = "t2.micro"
  key_name      = "up_running01"

  vpc_security_group_ids = [aws_security_group.lt_sg_01.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
  tags = {
    Name = "U_R_0[count.index]"
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

#output "public_ip" {
#  value = "${aws_instance.lt_ubuntu_01[count.index].public_ip}"
#}
