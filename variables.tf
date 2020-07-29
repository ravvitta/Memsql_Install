variable "region" {
  default = "us-west-2"
}

variable "vpc_id" {
  default = "vpc-99507af0"
}

variable "subnet_id" {
  default = "subnet-79a4de02"
}

variable "private_key_path" {
  default = "/Users/rvittal/MemSQL-Terraform/id_rsa"
}

variable "ssh_user" {
  default = "ec2-user"
}

variable "LeafCount" {
  default = 25
}

variable "ChildAggCount" {
  default = 6
}

variable "filepath" {
  default = "/Users/rvittal/MemSQL-Terraform/"
}
