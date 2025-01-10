data "aws_ami" "rhel9_server" {
  most_recent = true

  filter {
    name   = "owner-alias" 
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["rhel9"]
  }
}
