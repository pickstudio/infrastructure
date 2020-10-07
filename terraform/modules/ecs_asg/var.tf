variable "meta" {
  type = object({
    service  = string
    crew     = string
    team     = string
    resource = string
    env      = string
    role     = string
  })
}

variable "security_groups" {
  type        = list(string)
  description = "EC2 Security Groups"
}

variable "subnet_ids" {
  type        = list(string)
  description = "EC2 AZ subnets"
}

variable "scale_min" {
  type        = number
  description = "ASG instance minimum size"
}

variable "scale_desired" {
  type        = number
  description = "ASG instance desired size"
}

variable "scale_max" {
  type        = number
  description = "ASG instance maximum size"
}

variable "ami_id" {
  type        = string
  description = "EC2 AMI"
}

variable "instance_type" {
  type        = string
  description = "EC2 Instance Type"
}

variable "volume_size" {
  type        = number
  description = "EC2 Volume Size"
}

variable "cluster_name" {
  type        = string
  description = "ES Cluster Name"
}

variable "key_name" {
  type        = string
  description = "Key Pair Name"
}
