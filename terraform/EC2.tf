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

