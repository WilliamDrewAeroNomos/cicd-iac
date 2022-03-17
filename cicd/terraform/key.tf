resource "aws_key_pair" "iac-ci-key" {
  key_name   = "iac-ci-key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

