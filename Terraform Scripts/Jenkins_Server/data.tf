data "aws_ami" "rhel_9" {
  most_recent = true

  filter {
    name   = "owner-alias" 
    values = ["rhel_9"]
  }

  filter {
    name   = "name"
    values = ["rhel9"]
  }
}
  filter {
    name   = "virtualization_type"
    values = ["hvm:ebs-ssd"]
  }
}
