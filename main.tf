# -----------------
# VPC & Networking
# -----------------
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags                 = merge(var.tags, { Name = "SIEM-VPC" })
}

resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags                    = merge(var.tags, { Name = "SIEM-Subnet" })
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id
  tags   = merge(var.tags, { Name = "SIEM-IGW" })
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = merge(var.tags, { Name = "SIEM-RT" })
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.route_table.id
}

# -----------------
# Security Group
# -----------------
resource "aws_security_group" "siem_sg" {
  name        = "SIEM-SG"
  description = "Allow SSH and SIEM ports"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom SIEM Ports"
    from_port   = 8000
    to_port     = 9999
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "SIEM-SG" })
}

# -----------------
# EC2 Instances
# -----------------
resource "aws_instance" "elk" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.siem_sg.id]

  tags = merge(var.tags, { Name = "ELK-Server" })
}

resource "aws_instance" "splunk" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.siem_sg.id]

  tags = merge(var.tags, { Name = "Splunk-Server" })
}

resource "aws_instance" "cribl" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.siem_sg.id]

  tags = merge(var.tags, { Name = "Cribl-Server" })
}

