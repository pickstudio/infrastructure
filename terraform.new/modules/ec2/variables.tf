variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "volume_size" {
  type = number
}

variable "github_accounts" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_groups" {
  type = list
}

variable "associate_public_ip_address" {
  default = false
  type    = bool
}

variable "key_name" {
  type = string
}

variable "service" {
  type = string
}

variable "role" {
  type = string
}

variable "env" {
  type = string
}

variable "iam_instance_profile_name" {
  default = ""
  type    = string
}
