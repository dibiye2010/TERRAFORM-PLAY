
data "aws_ami" "amazon" { # Data Sources
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-2023.2.20231030.1-kernel-6.1-x86_64"] #use AMI Name
  }
  owners = ["amazon"]
}

variable "aws_region" {
  description = "creating a variable to hold the region value name"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "vpc cidr"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_sub1_cidr" {
  description = "public subnet cidr"
  type        = string
  default     = "10.0.0.0/24"
}

variable "private_sub1_cidr" {
  description = "private subnet cidr"
  type        = string
  default     = "10.0.1.0/24"
}


# variable "instance_type" {
#   description = "creating a variable to hold the instance type"
#   type        = string
#   default     = "t2.micro"
# }

variable "instance_key_pair" {
  description = "creating a variable to hold the key pair name"
  type        = string
  default     = "testkeypair"
}

variable "availability_zone" {
  description = "variable for avaibility zone"
  type        = string
  default     = "us-east-1a"

}

# variable "instance_type_list" {
#   description = "list of aws instance types"
#   type        = list(string)
#   default     = ["t3.micro", "t2.micro", "t2.nano", "t2.large"]
# }

variable "instance_type_map" {
  description = "map of instance types"
  type        = map(string)
  default = {
    "Dev"  = "t2.small"
    "Qa"   = "t2.micro"
    "Prod" = "t2.large"
  }

}

variable "instance_rename" {
  description = "renaming the instance"
  type        = string
  default     = "Hello_Dicha"
}

