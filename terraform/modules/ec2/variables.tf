variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "volume_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "desired_capacity" {
  type = number
}

variable "github_accounts" {
  type = string
}

variable "availability_zones" {
  type = list
}

variable "vpc_zone_identifier" {
  type = list
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
