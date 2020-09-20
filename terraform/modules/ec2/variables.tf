variable "github_accounts" {
  type = string
}

variable "ec2" {
  type = object({
    ami_id = string
    instance_type = string
    volume_size = number
    key_name = string
    subnet_id = string
    security_groups = list(string)
    associate_public_ip_address = bool
    iam_instance_profile_name = string
  })
}

variable "meta" {
  type = object({
    crew = string
    team = string
    resource = string
    env = string
    role = string
  })
}