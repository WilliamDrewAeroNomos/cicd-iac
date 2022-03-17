resource "aws_security_group" "artifactory-sg" {
  vpc_id      = aws_vpc.main.id
  name        = "artifactory-sg"
  description = "Security group for Artifactory instances"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 8081
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.artifactory-elb-securitygroup.id]
  }

  tags = {
    Name = "artifactory-sg"
  }
}

resource "aws_security_group" "gitlab-sg" {
  vpc_id      = aws_vpc.main.id
  name        = "gitlab-sg"
  description = "Security group for GitLab instances"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.gitlab-elb-securitygroup.id]
  }

  tags = {
    Name = "gitlab-sg"
  }
}

resource "aws_security_group" "dashboard-sg" {
  vpc_id      = aws_vpc.main.id
  name        = "dashboard-sg"
  description = "Security group for Dashboard instances"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.dashboard-elb-securitygroup.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.dashboard-elb-securitygroup.id]
  }

  tags = {
    Name = "dashboard-sg"
  }
}

resource "aws_security_group" "jenkins-sg" {
  vpc_id      = aws_vpc.main.id
  name        = "jenkins-sg"
  description = "Security group for Jenkins instances"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.jenkins-elb-securitygroup.id]
  }

  tags = {
    Name = "jenkins-sg"
  }
}

resource "aws_security_group" "sonar-sg" {
  vpc_id      = aws_vpc.main.id
  name        = "sonar-sg"
  description = "Security group for Sonar instances"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 9000
    to_port         = 9000
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.sonar-elb-securitygroup.id]
  }

  tags = {
    Name = "sonar-sg"
  }
}

#resource "aws_security_group" "allow-mariadb" {
#  vpc_id      = "${aws_vpc.main.id}"
#  name        = "allow-mariadb"
#  description = "Security group for a MariaDB instances"
#
#  ingress {
#    from_port       = 3306
#    to_port         = 3306
#    protocol        = "tcp"
#    security_groups = ["${aws_security_group.jenkins-sg.id}"] 
#  }
#
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#    self        = true
#  }
#
#  tags {
#    Name = "allow-mariadb"
#  }
#}

resource "aws_security_group" "sonardb-sg" {
  vpc_id      = aws_vpc.main.id
  name        = "sonardb-sg"
  description = "Security group for Sonar DB instances"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.sonar-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  tags = {
    Name = "sonardb-sg"
  }
}

resource "aws_security_group" "artifactorydb-sg" {
  vpc_id      = aws_vpc.main.id
  name        = "artifactorydb-sg"
  description = "Security group for Artifactory DB instances"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.artifactory-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  tags = {
    Name = "artifactorydb-sg"
  }
}

resource "aws_security_group" "gitlabdb-sg" {
  vpc_id      = aws_vpc.main.id
  name        = "gitlabdb-sg"
  description = "Security group for GitLab DB instances"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.gitlab-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  tags = {
    Name = "gitlabdb-sg"
  }
}

resource "aws_security_group" "allow-ssh-sg" {
  vpc_id      = aws_vpc.main.id
  name        = "allow-ssh-sg"
  description = "Allows SSH access"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  tags = {
    Name = "allow-ssh-sg"
  }
}

