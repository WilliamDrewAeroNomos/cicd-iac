data "aws_ami" "gitlab-image" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "tag:ci-component-name"
    values = ["gitlab-ci"]
  }
}

output "gitlab-ami-id" {
  value = data.aws_ami.gitlab-image.id
}

