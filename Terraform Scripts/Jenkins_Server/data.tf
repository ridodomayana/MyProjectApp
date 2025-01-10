data "aws_ami" "rhel9" {
  most_recent = true

  filter {
    name   = "owner-alias" 
    values = ["RHEL9-Server"]
  }

  filter {
    name   = "name"
    values = ["RHEL-9"]
  }

  filter {
    name   = "virtualization_type"
    values = ["hvm:ebs-ssd"]
  }
}



######-----AMAZON LINUX 2--------------####
data "aws_ami" "amazonlinux2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}
~

