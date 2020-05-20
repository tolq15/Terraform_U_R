variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 22
}

variable "ami" {
  type = map

  default = {
    "us-east-1" = "ami-07c1207a9d40bc3bd"
    "us-east-2" = "ami-07c1207a9d40bc3bd"
    "us-west-1" = "ami-07c1207a9d40bc3bd"
  }
}

variable "instance_count" {
  default = "4"
}

variable "instance_type" {
  default = "t2.nano"
}

variable "aws_region" {
  default = "us-east-2"
}


