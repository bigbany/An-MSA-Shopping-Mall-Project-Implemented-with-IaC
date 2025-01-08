#################### /eks_cluster_iam.tf
#################### for DEV_EKS
resource "aws_iam_role" "EKS_role" {
  name               = "${var.project}-${var.TYPE}-cluster-${var.uptime_S}"
  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
  tags = {
    TYPE    = "${var.project}-${var.TYPE}"
    TEAM    = "${var.TEAM}"
  }
}
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.EKS_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.EKS_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEBSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy" # This might need to be updated based on the exact policy ARN.
  role       = aws_iam_role.EKS_role.name
}