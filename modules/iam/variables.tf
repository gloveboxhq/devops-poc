variable "analyst_policy" {
  type = string
}

variable "admin_policy" {
  type = string
}

variable "read-replica-arn" {
  type = string
}

variable "directory-secret" {
  type = string
}

variable "directory-domain" {
  type    = string
  default = "corp.notglovebox.com"
}

variable "vpc_id" {
  type = string
}


variable "subnet_ids" {
  type = list(string)
}