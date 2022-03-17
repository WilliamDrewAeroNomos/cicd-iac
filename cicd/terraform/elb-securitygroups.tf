resource "aws_security_group" "artifactory-elb-securitygroup" {
  vpc_id      = aws_vpc.main.id
  name        = "artifactory-elb-sg"
  description = "Security group for the Artifactory ELB"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "artifactory-elb-sg"
  }
}

resource "aws_security_group" "gitlab-elb-securitygroup" {
  vpc_id      = aws_vpc.main.id
  name        = "gitlab-elb-sg"
  description = "Security group for the GitLab ELB"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "gitlab-elb-sg"
  }
}

resource "aws_security_group" "jenkins-elb-securitygroup" {
  vpc_id      = aws_vpc.main.id
  name        = "jenkins-elb-sg"
  description = "Security group for the Jenkins ELB"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-elb-sg"
  }
}

resource "aws_security_group" "sonar-elb-securitygroup" {
  vpc_id      = aws_vpc.main.id
  name        = "sonar-elb-sg"
  description = "Security group for the Sonar ELB"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sonar-elb-sg"
  }
}

resource "aws_security_group" "dashboard-elb-securitygroup" {
  vpc_id      = aws_vpc.main.id
  name        = "dashboard-elb-sg"
  description = "Security group for the Dashboard ELB"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dashboard-elb-sg"
  }
}

