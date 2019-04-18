module "blue" {
  source                      = "../single-stack"
  color                       = "blue"
  name                        = "${var.name}"
  max_size                    = "${var.blue_max_size}"
  min_size                    = "${var.blue_min_size}"
  desired_capacity            = "${var.blue_desired_capacity}"
  ami                         = "${var.blue_ami}"
  user_data                   = "${var.blue_user_data}"
  instance_type               = "${var.blue_instance_type}"
  disk_volume_size            = "${var.blue_disk_volume_size}"
  disk_volume_type            = "${var.blue_disk_volume_type}"
  spot_price                  = "${var.spot_price}"
  loadbalancers               = ["${var.loadbalancers}"]
  key_name                    = "${var.key_name}"
  security_groups             = ["${var.security_groups}"]
  iam_instance_profile        = "${var.iam_instance_profile}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  subnets                     = "${var.subnets}"
  health_check_grace_period   = "${var.health_check_grace_period}"
  termination_policies        = ["${var.termination_policies}"]
  target_group_arns           = ["${var.target_group_arns}"]
  health_check_type           = "${var.health_check_type}"
  wait_for_capacity_timeout   = "${var.wait_for_capacity_timeout}"
  tags                        = "${var.tags}"
}

module "green" {
  source                      = "../single-stack"
  color                       = "green"
  name                        = "${var.name}"
  max_size                    = "${var.green_max_size}"
  min_size                    = "${var.green_min_size}"
  desired_capacity            = "${var.green_desired_capacity}"
  ami                         = "${var.green_ami}"
  user_data                   = "${var.green_user_data}"
  instance_type               = "${var.green_instance_type}"
  disk_volume_size            = "${var.green_disk_volume_size}"
  disk_volume_type            = "${var.green_disk_volume_type}"
  spot_price                  = "${var.spot_price}"
  loadbalancers               = ["${var.loadbalancers}"]
  key_name                    = "${var.key_name}"
  security_groups             = ["${var.security_groups}"]
  iam_instance_profile        = "${var.iam_instance_profile}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  subnets                     = "${var.subnets}"
  health_check_grace_period   = "${var.health_check_grace_period}"
  termination_policies        = ["${var.termination_policies}"]
  target_group_arns           = ["${var.target_group_arns}"]
  health_check_type           = "${var.health_check_type}"
  wait_for_capacity_timeout   = "${var.wait_for_capacity_timeout}"
  tags                        = "${var.tags}"
}
