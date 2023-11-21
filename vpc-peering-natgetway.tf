resource "aws_vpc" "first-vpc" {
  cidr_block       = "10.0.0.0/20"
  instance_tenancy = "default"

  tags = {
    Name = "first vpc"
  }
}

resource "aws_subnet" "public-sub" {
  vpc_id     = aws_vpc.first-vpc.id
  cidr_block = "10.0.0.0/21"

  tags = {
    Name = "public-sub"
  }
}

resource "aws_subnet" "private-sub" {
  vpc_id     = aws_vpc.first-vpc.id
  cidr_block = "10.0.8.0/21"

  tags = {
    Name = "private-sub"
  }
}


resource "aws_security_group" "sg" {
  name        = "aws-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.first-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aws-sg"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.first-vpc.id

  tags = {
    Name = "igw-vpc-first"
  }
}


#resource "aws_internet_gateway" "igw-vpc01" {
#  vpc_id   = aws_vpc.first-vpc.id

#  tags = {
#    Name = "internet-getway"
#  }
#}


resource "aws_vpc" "first-vpc01" {
  cidr_block    = "10.0.0.0/20"
}


resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.first-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rt-connect-igw"
  }
}


resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public-sub.id
  route_table_id = aws_route_table.rt.id
}


resource "aws_key_pair" "key" {
  key_name   = "id_rsa.pub"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCmm2v8Ave+1mWnHVHBVjAdqMuZYeYnjNGnP3vh8vlqM+sekOVk1kJXkgolzEm9z7yi8DkLc5lDemU0aQWT71c92numcDpl20KesE1irN5xD+Vgm1tfSFhNWN7MZH6zydL0/4mqWow5JFsorGXUdAI8k3ceLxejs/0QZ9iBSvCuybl/ANJBElZxxBWDGqoBRbwcvgi6CHazdXHBzoaRkSTMciyQwMbIl7CV7U159Seh3Zv1jszV7fvG5exDSnwv7xM4xf9wyVgEouZy2PNvrlWbAhkoUbIyOnC8eCHC+tdqcyX49PQ7YJJ73dH6RkZQoniAKuuuyQubiJECGiXT4j4MVHqXFvCXuWE4J3uQTCnBrrJM2D6Jh/0GDOOEmExLNDqwflWwFE8bCjkUbpJ4KY4Pcy/p5RScpKbMep6KnEk0+5pTg7/BFChnkRJFvd8sCo7MO0uTTndmG8jRNiWc0zbUo5Q2SmjMQ4T7AwLJPWshWcWicEtZyUhvbkHAbRHJLfs= ubuntu@ip-172-31-10-35"
}



resource "aws_instance" "public-instance" {
  ami           = "ami-0361bbf2b99f46c1d" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public-sub.id
  vpc_security_group_ids  = [aws_security_group.sg.id]
  key_name   = "id_rsa.pub"

  tags = {
    Name = "publice-instance"
  }
}


resource "aws_eip" "lb" {
  instance = aws_instance.public-instance.id
  domain   = "vpc"
}
