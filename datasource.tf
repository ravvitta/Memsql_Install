data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}

data "aws_subnet" "example" {
  id       = var.subnet_id
}

data "aws_ami" "amazon_linux" {
  
  most_recent = true
  owners = ["137112412989"]

  filter {
    name = "name"

    values = [
      "amzn2-ami-hvm-2.0.20200617.0-x86_64-gp2",
    ]
  }
  }

