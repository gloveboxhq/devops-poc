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