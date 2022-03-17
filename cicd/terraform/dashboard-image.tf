data "aws_ami" "dashboard-image" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "tag:ci-component-name"
    values = ["dashboard-ci"]
  }
}

output "dashboard-ami-id" {
  value = data.aws_ami.dashboard-image.id
}

