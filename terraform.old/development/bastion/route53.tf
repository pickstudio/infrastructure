resource "aws_route53_record" "endpoint" {
  zone_id = data.terraform_remote_state.common.outputs.route53_pickstudio_zone_id
  name    = "basiton.pickstudio.io"
  type    = "A"
  ttl     = "60"
  records = [module.bastion.public_ip]
}
