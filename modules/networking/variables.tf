variable "vpc_name" {
    type = string
    default = "challenge_vpc"
}

variable "cidr_block" {
  type    = string
  default = "10.100.0.0/16"
}

variable "private_sn" {
  type    = list(string)
  default = ["10.100.0.0/24", "10.100.1.0/24"]
}

variable "public_sn" {
  type    = list(string)
  default = ["10.100.32.0/24", "10.100.42.0/24"]
}

variable "azs" {
  type = any
}