resource "aws_instance" "JenkinsServer" {
  ami                    = data.aws_ami.rhel8_server.id
  instance_type          = var.my_instance_type
  key_name               = var.my_key
  vpc_security_group_ids = [aws_security_group.web-traffic.id]

  tags = {
    "Name" = "Jenkins-Server"
}
}
