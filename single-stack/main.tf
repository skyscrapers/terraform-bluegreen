resource "aws_launch_configuration" "bluegreen_launchconfig" {
  image_id                    = "${var.ami}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${var.security_groups}"]
  iam_instance_profile        = "${var.iam_instance_profile}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  user_data                   = "${var.user_data}"
  spot_price                  = "${var.spot_price}"

  root_block_device {
    volume_type           = "${var.disk_volume_type}"
    volume_size           = "${var.disk_volume_size}"
    delete_on_termination = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  asg_name = "${var.name}-${var.color}"
}

resource "aws_autoscaling_group" "bluegreen_asg" {
  name                      = "${local.asg_name}"
  launch_configuration      = "${aws_launch_configuration.bluegreen_launchconfig.id}"
  vpc_zone_identifier       = ["${var.subnets}"]
  load_balancers            = ["${var.loadbalancers}"]
  max_size                  = "${var.max_size}"
  min_size                  = "${var.min_size}"
  desired_capacity          = "${var.desired_capacity}"
  health_check_type         = "${var.health_check_type}"
  health_check_grace_period = "${var.health_check_grace_period}"
  termination_policies      = ["${var.termination_policies}"]
  target_group_arns         = ["${var.target_group_arns}"]
  wait_for_capacity_timeout = "${var.wait_for_capacity_timeout}"
  initial_lifecycle_hook    = ["${var.initial_lifecycle_hooks}"]

  tags = ["${concat(
  list(
    map("key", "Name", "value", "${local.asg_name}", "propagate_at_launch", true),
    map("key", "Type", "value", "${var.name}", "propagate_at_launch", true),
    map("key", "Color", "value", "${var.color}", "propagate_at_launch", true)
  ),
  var.tags)
}"]
}
