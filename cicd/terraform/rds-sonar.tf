resource "aws_db_subnet_group" "sonardb-subnet" {
  name        = "sonardb-subnet"
  description = "Sonar RDS subnet group"
  subnet_ids  = [aws_subnet.main-private-1.id, aws_subnet.main-private-2.id]
}

resource "aws_db_instance" "sonardb-ci" {
  allocated_storage       = 100 # 100 GB of storage, gives us more IOPS than a lower number
  engine                  = "postgres"
  engine_version          = "9.6.3"
  instance_class          = "db.t2.large"
  identifier              = "sonardbci"
  name                    = "sonardbci"
  username                = "root"           # username
  password                = var.RDS_PASSWORD # password
  db_subnet_group_name    = aws_db_subnet_group.sonardb-subnet.name
  multi_az                = "false" # set to true to have high availability: 2 instances synchronized with each other
  vpc_security_group_ids  = [aws_security_group.sonardb-sg.id]
  storage_type            = "gp2"
  backup_retention_period = 30                                          # how long you’re going to keep your backups
  availability_zone       = aws_subnet.main-private-2.availability_zone # prefered AZ
  skip_final_snapshot     = true                                        # skip final snapshot when doing terraform destroy

  tags = {
    Name = "sonardb-instance"
  }
}

