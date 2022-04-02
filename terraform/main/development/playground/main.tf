locals {
  ec2 = {
    ami_id        = "ami-0257d109ee81daf0e" # AWS AMI pickstudio-ecs-1645372848 built by `./packer`
    instance_type = "t3a.medium"
    volume_size   = 64
    key_name      = "pickstudio"
    subnet_id     = data.terraform_remote_state.subnet_public.outputs.subnet_a_id
    security_groups = [
      data.terraform_remote_state.vpc.outputs.sg_basic_id,
      data.terraform_remote_state.vpc.outputs.sg_members_id,
    ]
    associate_public_ip_address = true
    iam_instance_profile_name = module.instance_profile.profile_name
  }

  meta = {
    crew     = "pickstudio",
    team     = "platform",
    resource = "containers",
    env      = "development",
    role     = "playground",
  }
}

module "instance_profile" {
  source = "../../../modules/instance_profile"

  name               = "${local.meta.crew}-${local.meta.role}"
  policy             = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
              "s3:Get*",
              "s3:Describe*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

module "playground_ec2" {
  source = "../../../modules/ec2"
  meta            = local.meta
  ec2             = local.ec2
}

resource "aws_route53_record" "endpoint" {
  zone_id = data.terraform_remote_state.route53.outputs.route53_pickstudio_zone_id
  name    = "playground.development.pickstudio.io"
  type    = "CNAME"
  ttl     = "60"
  records = [module.playground_ec2.public_dns]
}
