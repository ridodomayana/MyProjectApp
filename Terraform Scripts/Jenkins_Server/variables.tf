variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the Subnet"
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "Instance type for the RHEL 9 server"
  default     = "t2.micro"
}

variable "key_pair_name" {
  description = "Name of the AWS key pair to use for SSH access"
  default     = "terraform" # Replace with your actual key pair name
}









variable "region" {
  type    = string
  default = "us-east-2"
}
variable "my_instance_type" {
  type    = string
  default = "t2.micro"
}


variable "my_key" {
  description = "AWS EC2 Key pair that needs to be associated with EC2 Instance"
  type        = string
  default     = "terraform"
}

variable "ingressrules" {
  type    = list(number)
  default = [22, 80, 443, 8080, 8090, 9000, 8081, 2479]
}

variable "egressrules" {
  type    = list(number)
  default = [25, 80, 443, 8080, 8090, 3306, 53]
}
