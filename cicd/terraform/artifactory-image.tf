data "aws_ami" "artifactory-image" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "tag:ci-component-name"
    values = ["artifactory-ci"]
  }
}

output "artifactory-ami-id" {
  value = data.aws_ami.artifactory-image.id
}

