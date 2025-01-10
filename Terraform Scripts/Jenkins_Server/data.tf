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

