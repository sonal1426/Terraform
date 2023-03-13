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