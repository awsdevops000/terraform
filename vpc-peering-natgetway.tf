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
  vpc_id =  aws_vpc.first-vpc.id

  tags = {
    Name = "igw-vpc-first"
  }
}


resource "aws_internet_gateway_attachment" "igw-vpc" {
  internet_gateway_id = aws_internet_gateway.igw.id
  vpc_id              = aws_vpc.first-vpc.id
}



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
  key_name   = "terraform-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDYu+fPAkktvezzuypWMfPU7IKFZQw5ofMA8PN+FE3wl9FiXhJeSX5EnShN6tqUlnvvSgoOYRbr3RJ01fBvbjriDKwkkqm8Kmq8Wo2uDVDhqxdKFpRn0VmzzGf0Tw0Tcbmm49JjhBoCokKaNZowM0O5dbJp/yNkIJy1nptg0utnXXrkpBfnnNIqG5kIJ5pQd245hp0OfBI+Td8AGVSDEGAJ36ZXQqo7DWntil4mUJ/SlelsLgvoGEYPBBNU3NmgALuLjWzacSthCQxNJsX781mVl1qZVeJRtSN6EcC5m3bfWTuLhufYkxx61ZDvOARozwPZDeP9bM6/rpQ3SEwxH5s59JVrobklm+wbot56IOngsh12qOh2uQYB4jhTCKGFOGfmkkHqI4dyK4t4xWvw/Qy54szgVewBGB80XdzabLrNkc/gve+Z7bWvUCkBQ54+s23GN1Z4R4l6VBWC+5mODecwyuug+jbT8yoeujgcsL8k2AiSRTs4NZC8tpjhrO79sP8= ubuntu@ip-172-31-8-14"
}


resource "aws_eip" "lb" {
  instance = aws_instance.web.id
  domain   = "vpc"

resource "aws_instance" "public-instance" {
  ami           = "ami-0361bbf2b99f46c1d" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public-sub.id
  vpc_security_group_ids  = [aws_security_group.sg.id]
  key_name   = "terraform-key"

  tags = {
    Name = "publice-instance"
  }
}

}

resource "aws_eip" "public-lb" {
  instance = aws_instance.public-instance.id
  domain   = "vpc"
}
