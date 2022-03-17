resource "aws_launch_configuration" "dashboard-launchconfig" {
  name_prefix     = "dashboard-launchconfig"
  image_id        = data.aws_ami.dashboard-image.id
  instance_type   = "t2.xlarge"
  key_name        = aws_key_pair.iac-ci-key.key_name
  security_groups = [aws_security_group.dashboard-sg.id]
  user_data       = <<-EOF
        #!/bin/bash -v

        echo "Update artifactory.api.properies"
        echo 'artifactory.endpoint=artifactory/' | tee -a /etc/init.d/artifactory.api.properties
        echo 'artifactory.servers[0]=http://artifactory-ci.devgovcio.com' | tee -a /etc/init.d/artifactory.api.properties
        echo 'artifactory.apiKeys[0]=${var.ARTIFACTORY_API_KEY}' | tee -a /etc/init.d/artifactory.api.properties

	service artifactory_collector restart

        echo "Update gitlab.api.properies"
        echo 'gitlab.host=gitlab-ci.devgovcio.com' | tee -a /etc/init.d/gitlab.api.properties

	service gitlab_collector restart

        echo "Update sonar.api.properies"
        echo 'sonar.servers[0]=http://sonar-ci.devgovcio.com' | tee -a /etc/init.d/sonar.api.properties
        echo 'sonar.username=admin' | tee -a /etc/init.d/sonar.api.properties
        echo 'sonar.login=admin' | tee -a /etc/init.d/sonar.api.properties

	service sonar_collector restart

        echo "Update jenkins.api.properies"
        echo 'jenkins.servers[0]=http://jenkins-ci.devgovcio.com' | tee -a /etc/init.d/jenkins.api.properties
        echo 'jenkins.usernames[0]=${var.JENKINS_COLLECTOR_USERNAME}' | tee -a /etc/init.d/jenkins.api.properties
        echo 'jenkins.apiKeys[0]=Gcio!2018' | tee -a /etc/init.d/jenkins.api.properties

	service jenkins_collector restart

EOF

}

resource "aws_autoscaling_group" "dashboard-autoscaling" {
  name                      = "dashboard-autoscaling"
  vpc_zone_identifier       = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  launch_configuration      = aws_launch_configuration.dashboard-launchconfig.name
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  load_balancers            = [aws_elb.dashboard-elb.name]
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "Dashboard CI"
    propagate_at_launch = true
  }
}

