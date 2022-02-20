packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ecs-ec2" {
  ami_name              = "ecs"
  instance_type         = "c5.xlarge"
  region                = "ap-northeast-2"
  source_ami            = "ami-073a0375a611be5fa"
  ssh_username          = "ec2-user"

  security_group_id = "sg-0e2af638e10fe1a09"
  subnet_id = "subnet-0579f0c0da98e0d19"
  vpc_id = "vpc-09adb720f8676cd1e"

  associate_public_ip_address = true
  availability_zone = "ap-northeast-2a"

  security_group_filter {
    filters = {
      "tag:Name": "pickstudio-basic"
    }
  }

  launch_block_device_mappings {
    device_name = "/dev/sda1"
    delete_on_termination = true
    volume_size = 40
    volume_type = "gp3"
  }
}

build {
  name = "build-aws-ec2-ecs"
  sources = [
    "source.amazon-ebs.ecs-ec2"
  ]

  provisioner "ansible" {
    host_alias = "pickstudio_ecs"
    playbook_file = "./provisionings/ecs.yml"

#    extra_arguments = [
#      "--extra-vars", "Region={{user `Region`}} Stage={{user `Stage`}}",
#    ]
  }
}
