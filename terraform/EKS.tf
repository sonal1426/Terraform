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