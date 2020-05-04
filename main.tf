provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "lt_ubuntu_01" {
  ami           = "ami-07c1207a9d40bc3bd"
  instance_type = "t2.micro"

  tags = {
    Name = "U_R_01"
  }
}

# provider.aws: version = "~> 2.60"
