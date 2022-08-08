resource "aws_vpc" "bitcoin" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "ECS-EFS-VPC"
  }
}

resource "aws_subnet" "alpha" {
  vpc_id            =  aws_vpc.bitcoin.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.1.0/24"
  
  tags = {
    Name = "ECS-EFS-SUBNET"
  }
}


