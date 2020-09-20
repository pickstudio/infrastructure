resource "aws_instance" "ec2" {
  ami = var.ec2.ami_id
  instance_type = var.ec2.instance_type

  tags = {
    Name = "${var.meta.role}-${var.meta.env}"
    Role = var.meta.role
    Environment = var.meta.env
    Resource = var.meta.resource
    Team = var.meta.team
    Crew = var.meta.crew
  }

  user_data     = base64encode(data.template_file.ec2.rendered)
  key_name = var.ec2.key_name

  iam_instance_profile = var.ec2.iam_instance_profile_name

  ebs_optimized = false

  vpc_security_group_ids             = var.ec2.security_groups
  subnet_id = var.ec2.subnet_id
  associate_public_ip_address = var.ec2.associate_public_ip_address

  root_block_device {
    volume_type           = "gp2"
    volume_size           = var.ec2.volume_size
    delete_on_termination = true
  }
}

data "template_file" "ec2" {
  template = "${file("${path.module}/files/setup.sh")}"

  vars = {
    github_accounts = var.github_accounts
  }
}
