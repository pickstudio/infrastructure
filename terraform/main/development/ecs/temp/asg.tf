data "template_file" "user_data" {
  template = "${file("./ecs.sh")}"

  vars = {
    cluster_name        = "${aws_ecs_cluster.cluster.name}"
    github_accounts = local.github_accounts
  }
}

resource "aws_launch_configuration" "static_cluster_instances" {
  name_prefix                 = "${local.meta.crew}-${local.meta.env}-ci-"
  instance_type               = "${var.static_instance_type}"
  image_id                    = "${var.ami_id}"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = false
  user_data                   = "${data.template_file.user_data.rendered}"
  iam_instance_profile        = "${var.iam_instance_profile}"

  security_groups = [
    "${aws_security_group.cluster_instance.id}",
    "${var.security_group__docker_ephemeral_id}",
    "${var.security_group__default_id}"
  ]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "${var.volume_size}"
    delete_on_termination = "${var.persistence_root_device ? false : true}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "static_cluster_instances" {
  name = "${var.name}_cluster_instance"
  # availability_zones = var.zones
  vpc_zone_identifier  = var.private_subnet_nat_ids
  launch_configuration = "${aws_launch_configuration.static_cluster_instances.name}"
  max_size             = "${var.static_max_size}"
  min_size             = "${var.static_min_size}"
  desired_capacity     = "${var.static_desired_capacity}"

  force_delete         = true
  termination_policies = ["OldestInstance", "Default"]

  tag {
    key                 = "Name"
    value               = "${var.name} cluster instance"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "datadog"
    value               = "monitored"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "country_code"
    value               = "${var.tag_country_code}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "stage"
    value               = "${var.tag_stage}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Environment"
    value               = "${var.tag_stage}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Service"
    value               = "${var.tag_service}"
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "dynamic_cluster_instance" {
  name_prefix                 = "${var.name}-ci-dynamic-"
  instance_type               = "${var.dynamic_instance_type}"
  image_id                    = "${var.ami_id}"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = false
  spot_price                  = "${var.dynamic_spot_price}"
  user_data                   = "${data.template_file.user_data.rendered}"
  iam_instance_profile        = "${var.iam_instance_profile}"

  security_groups = [
    "${aws_security_group.cluster_instance.id}",
    "${var.security_group__docker_ephemeral_id}",
    "${var.security_group__default_id}"
  ]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "${var.volume_size}"
    delete_on_termination = "${var.persistence_root_device ? false : true}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "dynamic_cluster_instance" {
  name = "${var.name}-ci-dynamic"
  # availability_zones = var.zones
  vpc_zone_identifier  = var.private_subnet_nat_ids
  launch_configuration = "${aws_launch_configuration.dynamic_cluster_instance.name}"
  min_size             = "${var.dynamic_min_size}"
  max_size             = "${var.dynamic_max_size}"
  desired_capacity     = "${var.dynamic_desired_capacity}"

  force_delete         = true
  termination_policies = ["OldestInstance", "Default"]

  tag {
    key                 = "Name"
    value               = "${var.name} dynamic cluster instance"
    propagate_at_launch = "true"
  }
}
