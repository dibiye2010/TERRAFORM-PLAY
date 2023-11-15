# template for the ressources
# vpc
resource "aws_vpc" "terra_vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "terra_vpc"
  }
}


# public subnet

resource "aws_subnet" "terra_pub_sub1" {
  vpc_id                  = aws_vpc.terra_vpc.id
  cidr_block              = var.public_sub1_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "terra_pub_sub1"
  }
}

# private subnet

resource "aws_subnet" "terra_priv_sub1" {
  vpc_id                  = aws_vpc.terra_vpc.id
  cidr_block              = var.private_sub1_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone

  tags = {
    Name = "terra_priv_sub1"
  }
}

# internet gateway

resource "aws_internet_gateway" "terra_igw" {
  vpc_id = aws_vpc.terra_vpc.id

  tags = {
    Name = "terra_igw"
  }
}

# public route table

resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.terra_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra_igw.id
  }

  tags = {
    Name = "pub_rt"
  }
}
# private route table by default in aws
resource "aws_route_table" "priv_rt" {
  vpc_id = aws_vpc.terra_vpc.id


  tags = {
    Name = "private_rt"
  }
}


# association pub rt with public subnet

resource "aws_route_table_association" "pub_sub_rt" {
  route_table_id = aws_route_table.pub_rt.id
  subnet_id      = aws_subnet.terra_pub_sub1.id
}
# association pub rt with private subnet
resource "aws_route_table_association" "priv_sub_rt" {
  route_table_id = aws_route_table.priv_rt.id
  subnet_id      = aws_subnet.terra_priv_sub1.id
}

# security group
resource "aws_security_group" "allow_shhweb" {
  name        = "allow_shhweb"
  description = "Allow shh and web traffic"
  vpc_id      = aws_vpc.terra_vpc.id

  ingress {
    description = "Allow shh inbound traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow web inbound traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # reverse traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_shhweb"
  }
}
# public instance
resource "aws_instance" "terra-ec2" {
  ami                         = data.aws_ami.amazon.id
  associate_public_ip_address = true
  instance_type               = var.instance_type_map["Qa"]
  # instance_type               = var.instance_type_list[1] #t2.micro switching types will terminate instance
  key_name        = var.instance_key_pair
  subnet_id       = aws_subnet.terra_pub_sub1.id
  security_groups = [aws_security_group.allow_shhweb.id]
  count           = 3
  user_data       = file("install_apache.sh")

  tags = {
    Name = "terra-ec2-${var.instance_rename}-${count.index}" #string interpolation
  }
  depends_on = [aws_security_group.allow_shhweb] # dependency even though implicit
}
#string interpolation to subtitute the value of a variable inside the string whe the code run

resource "aws_instance" "terra-instance" {
  ami = data.aws_ami.amazon.id
  # instance_type   = var.instance_type              
  # instance_type   = var.instance_type_list[1]
  instance_type   = var.instance_type_map["Qa"]
  key_name        = var.instance_key_pair
  subnet_id       = aws_subnet.terra_priv_sub1.id
  security_groups = [aws_security_group.allow_shhweb.id]

  tags = {
    Name = "terra-instance"
  }
  depends_on = [aws_security_group.allow_shhweb]

}