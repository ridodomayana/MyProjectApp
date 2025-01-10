# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "RHEL9-VPC"
  }
}

# Subnet
resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2a" # Replace with your preferred AZ
  tags = {
    Name = "RHEL9-Subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "RHEL9-InternetGateway"
  }
}

# Route Table
resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "RHEL9-RouteTable"
  }
}

resource "aws_route_table_association" "main_rta" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_route_table.id
}

# EC2 Instance
resource "aws_instance" "rhel9_server" {
  ami           = data.aws_ami.rhel9.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main_subnet.id
  key_name      = var.key_pair_name

  security_group_ids = [
    aws_security_group.rhel9_sg.id
  ]

  tags = {
    Name = "RHEL9-Server"
  }
}



############################################



resource "aws_instance" "JenkinsServer" {
  ami                    = data.aws_ami.rhel9.id
  instance_type          = var.my_instance_type
  key_name               = var.my_key
  vpc_security_group_ids = [aws_security_group.web-traffic.id]

  tags = {
    "Name" = "New_Jenkin-Server"
}
}




####### Amazon Linux 2 ############
resource "aws_instance" "JenkinsServer" {
  ami                    = data.aws_ami.amazonlinux2.id
  instance_type          = var.my_instance_type
  key_name               = var.my_key
  vpc_security_group_ids = [aws_security_group.web-traffic.id]

  tags = {
    "Name" = "Jenkins-Server"
  }
}

