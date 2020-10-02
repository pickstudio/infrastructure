
variable "meta" {
  type = object({
    crew = string
    team = string
    resource = string
    env = string
    role = string
    service = string
  })
  description = "set infomations meta, requirement env, role, service"
}


variable "vpc_id" {
  type = string
  description = "get pickstudio VPC id"
}