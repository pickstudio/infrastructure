resource "aws_instance" "bastion" {
  ami = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "${var.service}-${var.role}-${var.env}"
    Service = var.service
    Environmen = var.env
    Role = var.role
  }

  user_data     = base64encode(data.template_file.ec2.rendered)
  key_name = var.key_name

  iam_instance_profile = var.iam_instance_profile_name

  ebs_optimized = false

  vpc_security_group_ids             = var.security_groups
  subnet_id = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address

  root_block_device {
    volume_type           = "gp2"
    volume_size           = var.volume_size
    delete_on_termination = true
  }
}
