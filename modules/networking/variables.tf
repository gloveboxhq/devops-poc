/*
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
  default = ["10.100.0.0/18", "10.100.64.0/24"]
}

variable "public_sn" {
  type    = list(string)
  default = ["10.100.128.0/24"]
}

variable "rds_db_sn" {
  type = list(string)
  default = ["10.100.192.0/24"]
}

variable "azs" {
  type = any
}*/

variable "directory_arn" {
  type = string
}

variable "directory_service_ips" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "domain_name" {
  type = string
}

variable "vpn_password" {
  type = string
}