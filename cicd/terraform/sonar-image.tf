data "aws_ami" "sonar-image" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "tag:ci-component-name"
    values = ["sonar-ci"]
  }
}

output "sonar-ami-id" {
  value = data.aws_ami.sonar-image.id
}

