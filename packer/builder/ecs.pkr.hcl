packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ecs-ec2" {
  ami_name        = "pickstudio-ecs-arm-64-{{timestamp}}"
  ami_description = "based on aws official ecs ami"
  instance_type   = "c6g.xlarge"
  region          = "ap-northeast-2"
  ssh_username    = "ec2-user"
  /*
source_ami => \
aws ssm get-parameters \
  --region ap-northeast-2 \
  --names /aws/service/ecs/optimized-ami/amazon-linux-2/recommended \
  | jq ".Parameters[0].Value | fromjson | .image_id"
  */
  source_ami = "ami-09f5ad92a3455ab0f" # for arm64

  security_group_id = "sg-09428512ecb5d19c6" # vpc:pickstudio // sg: public-members
  subnet_id         = "subnet-0579f0c0da98e0d19"
  vpc_id            = "vpc-09adb720f8676cd1e"

  associate_public_ip_address = true
  availability_zone           = "ap-northeast-2a"

  launch_block_device_mappings {
    device_name           = "/dev/xvda"
    delete_on_termination = true
    volume_size           = 40
    volume_type           = "gp3"
  }
}

build {
  name = "pickstudio-ecs-build"
  sources = [
    "source.amazon-ebs.ecs-ec2"
  ]

  provisioner "ansible" {
    host_alias    = "pickstudio_ecs"
    playbook_file = "./provisionings/ecs.yml"

    #    extra_arguments = [
    #      "--extra-vars", "Region={{user `Region`}} Stage={{user `Stage`}}",
    #    ]
  }
}
