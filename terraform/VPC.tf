provider "aws" {
  region = "us-east-1"
}

##### VPC #####
resource "aws_vpc" "Himanshu" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    tags = {
        Name = "Himanshu"
    }
}

 ##### Public-Subnet #####
resource "aws_subnet" "Himanshu-PubSub" {
    vpc_id = "${aws_vpc.Himanshu.id}"
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = "true"
    tags = {
        Name = "Himanshu-PubSub"
    }
}

##### Private-Subnet #####
resource "aws_subnet" "Himanshu-PriSub" {
    vpc_id = "${aws_vpc.Himanshu.id}"
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = "false"
    tags = {
        Name = "Himanshu-PriSub"
    }
}

##### Internet-Gateway #####
resource "aws_internet_gateway" "Himanshu-IG" {
    vpc_id = "${aws_vpc.Himanshu.id}"
    tags = {
        Name = "Himanshu-IG"
    }
}

##### Nat-Gateway #####
resource "aws_nat_gateway" "Himanshu-NG" {
    allocation_id = aws_eip.Himanshu-NG.id
    subnet_id     = aws_subnet.Himanshu-NG.id
    tags = {
        Name = "Himanshu-NG"
    }
}

resource "aws_nat_gateway" "Himanshu-PrivateNG" {
    connectivity_type = "private"
    subnet_id         = aws_subnet.Himanshu-PrivateNG.id
    tags = {
        Name = "Himanshu-PrivateNG"
    }
}

##### Routing Table for Internet Gateway #####
resource "aws_route_table" "Himanshu-RT" {
    vpc_id = aws_vpc.Himanshu.id
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Himanshu-IG.id
    tags = {
        Name = "Himanshu-RT"
    }
}
























