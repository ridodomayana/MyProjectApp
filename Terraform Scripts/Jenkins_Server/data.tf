data "aws_ami" "rhel9" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-9-*"] # Matches AMIs with RHEL 9 in the name
  }

  filter {
    name   = "owner-id"
    values = ["309956199498"] # Red Hat official AWS account ID
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

