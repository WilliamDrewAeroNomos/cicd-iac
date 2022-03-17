resource "aws_launch_configuration" "gitlab-launchconfig" {
  name_prefix     = "gitlab-launchconfig"
  image_id        = data.aws_ami.gitlab-image.id
  instance_type   = "t2.large"
  key_name        = aws_key_pair.iac-ci-key.key_name
  security_groups = [aws_security_group.gitlab-sg.id]
  user_data       = <<-EOF
        #!/bin/bash -v

	echo "Install the GitLab CE package"
	sudo EXTERNAL_URL="http://${aws_route53_record.gitlab-ci.name}" yum install -y gitlab-ce

	echo "Restart Gitlab..."
	sudo gitlab-ctl start

EOF

}

resource "aws_autoscaling_group" "gitlab-autoscaling" {
  name                      = "gitlab-autoscaling"
  vpc_zone_identifier       = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  launch_configuration      = aws_launch_configuration.gitlab-launchconfig.name
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  load_balancers            = [aws_elb.gitlab-elb.name]
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "GitLab CI"
    propagate_at_launch = true
  }
}

