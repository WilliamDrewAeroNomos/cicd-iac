resource "aws_launch_configuration" "sonar-launchconfig" {
  name_prefix     = "sonar-launchconfig"
  image_id        = data.aws_ami.sonar-image.id
  instance_type   = "t2.large"
  key_name        = aws_key_pair.iac-ci-key.key_name
  security_groups = [aws_security_group.sonar-sg.id]
  user_data       = <<-EOF
        #!/bin/bash -v

	echo "Build /opt/sonar/conf/sonar.properties file"
        echo 'sonar.jdbc.url=jdbc:postgresql://${aws_db_instance.sonardb-ci.endpoint}/sonar' | tee -a /opt/sonar/conf/sonar.properties
        echo 'sonar.jdbc.username=root' | tee -a /opt/sonar/conf/sonar.properties
        echo 'sonar.jdbc.password=${var.RDS_PASSWORD}' | tee -a /opt/sonar/conf/sonar.properties

	echo "Build ./pgpass file"
        echo '${aws_db_instance.sonardb-ci.endpoint}:postgres:root:${var.RDS_PASSWORD}' | tee -a ~/.pgpass
	sudo chmod 0600 ~/.pgpass

	echo "Build /tmp/postgres-config/createdb_sonar.sql file"
        echo 'CREATE DATABASE sonar;' | tee -a /tmp/postgres-config/createdb_sonar.sql
        echo 'CREATE USER sonar WITH PASSWORD '${var.RDS_PASSWORD}';' | tee -a /tmp/postgres-config/createdb_sonar.sql
        echo 'GRANT ALL PRIVILEGES ON DATABASE sonar TO sonar;' | tee -a /tmp/postgres-config/createdb_sonar.sql

	echo "Create sonar database, user and grant privileges"
        sudo psql --host=${element(split(":", aws_db_instance.sonardb-ci.endpoint), 0)} --port=5432 --dbname=postgres --username=root --file=/tmp/postgres-config/createdb_sonar.sql
        sudo service sonar restart
EOF

}

resource "aws_autoscaling_group" "sonar-autoscaling" {
  name                      = "sonar-autoscaling"
  vpc_zone_identifier       = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  launch_configuration      = aws_launch_configuration.sonar-launchconfig.name
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  load_balancers            = [aws_elb.sonar-elb.name]
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "Sonar CI"
    propagate_at_launch = true
  }
}

