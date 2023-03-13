terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.50.0"
    }
  }
}

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

##### PrivateNG #####
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

##### EC2-Instance #####
resource "aws_instance" "Himanshu-EC2" {
  ami           = "ami-0cca134ec43cf708f"
  instance_type = "t2.micro"
  tags = {
    Name = "Himanshu-EC2"
  }
}

##### Availability-Zone #####
data "aws_availability_zones" "Himanshu-AZ" {
  all_availability_zones = true

  filter {
    name   = "opt-in-status"
    values = ["not-opted-in", "opted-in"]
  }
}

##### RDS #####
resource "aws_rds_cluster" "Himanshu-RDS" {
  cluster_identifier      = "aurora-cluster-demo"
  availability_zones      = ["us-west-2a", "us-west-2b", "us-west-2c"]
  database_name           = "mydb"
  master_username         = "foo"
  master_password         = "bar"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
}

##### EKS #####
resource "aws_eks_cluster" "Himanshu-EKS" {
  name     = "Himanshu-EKS"
  role_arn = aws_iam_role.Himanshu-EKS.arn

  vpc_config {
    subnet_ids = [aws_subnet.Himanshu-EKS1.id, aws_subnet.Himanshu-EKS2.id]
  }
}

depends_on = [
    aws_iam_role_policy_attachment.Himanshu-EKS-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.Himanshu-EKS-AmazonEKSVPCResourceController,
  ]

output "endpoint" {
  value = aws_eks_cluster.Himanshu-EKS.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.Himanshu-EKS.certificate_authority[0].data
}