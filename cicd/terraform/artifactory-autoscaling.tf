resource "aws_launch_configuration" "artifactory-launchconfig" {
  name_prefix     = "artifactory-launchconfig"
  image_id        = data.aws_ami.artifactory-image.id
  instance_type   = "t2.large"
  key_name        = aws_key_pair.iac-ci-key.key_name
  security_groups = [aws_security_group.artifactory-sg.id]
  user_data       = <<-EOF
	#!/bin/bash -v
	echo 'url=jdbc:mysql://${aws_db_instance.artifactorydb-ci.endpoint}/artdb?characterEncoding=UTF-8&elideSetAutoCommits=true' | tee -a /etc/opt/jfrog/artifactory/etc/db.properties
	echo 'username=root' | tee -a /etc/opt/jfrog/artifactory/etc/db.properties
	echo 'password=${var.RDS_PASSWORD}' | tee -a /etc/opt/jfrog/artifactory/etc/db.properties
	mysql -h ${element(split(":", aws_db_instance.artifactorydb-ci.endpoint), 0)} -P 3306 -u root -p${var.RDS_PASSWORD} < /tmp/mysql-config/createdb_artifactory.sql

	sudo service artifactory restart
EOF

}

resource "aws_autoscaling_group" "artifactory-autoscaling" {
  name                      = "artifactory-autoscaling"
  vpc_zone_identifier       = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  launch_configuration      = aws_launch_configuration.artifactory-launchconfig.name
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  load_balancers            = [aws_elb.artifactory-elb.name]
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "Artifactory CI"
    propagate_at_launch = true
  }
}

