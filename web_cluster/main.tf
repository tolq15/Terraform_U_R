provider "aws" {
  region  = "us-east-2"
  version = "~> 2.60"
}

# This resource specifies how to configure each EC2 instance
# in Auto Scaling Group (ASG)
resource "aws_launch_configuration" "lt_ubuntu_01" {
  ami           = "ami-07c1207a9d40bc3bd"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.lt_sg_01.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
  tags = {
    Name = "U_R_01"
  }

  # Define how this resource should be created, updated and destroied.
  # AWS create new EC2 instance before destroing failed one.
  lifecycle {
    create_before_destroy = true
}


resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.lt_ubuntu_01.name
#  vpc_zone_identifier  = data.aws_subnet_ids.default.ids

#  target_group_arns = [aws_lb_target_group.asg.arn]
#  health_check_type = "ELB"

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
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

  # This setting should be the same as for parent object - aws_launch_configuration
  lifecycle {
    create_before_destrpu = true
}

output "public_ip" {
  value = "${aws_instance.lt_ubuntu_01.public_ip}"
}
