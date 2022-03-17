data "aws_ami" "jenkins-image" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "tag:ci-component-name"
    values = ["jenkins-ci"]
  }
}

output "jenkins-ami-id" {
  value = data.aws_ami.jenkins-image.id
}

