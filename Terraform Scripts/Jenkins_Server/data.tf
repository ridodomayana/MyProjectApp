data "aws_ami" "rhel8_server" {
  most_recent = true

  filter {
    name   = "owner-alias" 
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["rhel8"]
  }
}
