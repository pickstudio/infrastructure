
data "aws_iam_role" "ecs_role" {
  name = "ecsInstanceRole"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = var.cluster_name
  role = data.aws_iam_role.ecs_role.id
}

data "template_cloudinit_config" "ciconfig" {
  gzip = true
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/userdata/cloudinit.yaml", {
      ecs_cluster_name : var.cluster_name
    })
  }
}


resource "aws_launch_template" "lt" {
  name          = var.cluster_name
  image_id      = var.ami_id
  instance_type = var.instance_type
  ebs_optimized = false

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type           = "gp3"
      volume_size           = var.volume_size
      delete_on_termination = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    security_groups             = var.security_groups
    associate_public_ip_address = true # debugging 하면서 볼려고..
    delete_on_termination       = true
  }

  key_name = var.key_name

  user_data = data.template_cloudinit_config.ciconfig.rendered
}

resource "aws_autoscaling_group" "asg" {
  name = "${var.purpose}-${var.cluster_name}"

  min_size         = var.scale_min
  desired_capacity = var.scale_desired
  max_size         = var.scale_max

  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300
  default_cooldown          = 300
  termination_policies = [
    "OldestLaunchConfiguration",
    "OldestInstance"
  ]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  tag {
    key                 = "Name"
    value               = "${var.purpose}-${var.cluster_name}"

    propagate_at_launch = true
  }
  tag {
    key                 = "Service"
    value               = var.meta.service
    propagate_at_launch = true
  }
  tag {
    key                 = "Crew"
    value               = var.meta.crew
    propagate_at_launch = true
  }
  tag {
    key                 = "Team"
    value               = var.meta.team
    propagate_at_launch = true
  }
  tag {
    key                 = "Environment"
    value               = var.meta.env
    propagate_at_launch = true
  }
  tag {
    key                 = "Cluster"
    value               = var.cluster_name
    propagate_at_launch = true
  }
  tag {
    key                 = "Repository"
    value               = var.meta.repository
    propagate_at_launch = true
  }
  depends_on = [aws_launch_template.lt]
}