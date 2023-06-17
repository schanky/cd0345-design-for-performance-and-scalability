# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  region = "us-east-1"
  shared_credentials_files = [ "/Users/gene/.aws/credentials" ]
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "UdacityT2" {
  ami = "ami-022e1a32d3f742bd8"
  subnet_id = "subnet-07df3cc8999175da2"
  count = 4
  instance_type = "t2.micro"
  tags = {
    name = "UdacityT2"
  }
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "UdacityM4" {
  ami = "ami-022e1a32d3f742bd8"
  subnet_id = "subnet-07df3cc8999175da2"
  count = 2
  instance_type = "m4.large"
  tags = {
    name = "UdacityM4"
  }
}