# pickstudio.io
resource "aws_route53_zone" "pickstudio_io" {
  name = "pickstudio.io"

  comment = "Managed by Terraform"
}

# # for aws acm validation
# resource "aws_route53_record" "pickstudio_acm_validation" {
#   zone_id = aws_route53_zone.pickstudio_io.zone_id
#   name    = "_4fca4868e4a0e835bd025bc79e1e7591.pickstudio.io."
#   type    = "CNAME"
#   ttl     = "300"
#   records = [
#     "_a2f763f21db728b89d13635d502a928c.auiqqraehs.acm-validations.aws."
#   ]
# }

# # for github validation
# resource "aws_route53_record" "pickstudio_github_validation" {
#   zone_id = aws_route53_zone.pickstudio_io.zone_id
#   name    = "_github-challenge-pickstudio.pickstudio.io."
#   type    = "TXT"
#   ttl     = "300"
#   records = [
#     "f85cb7b730"
#   ]
# }
