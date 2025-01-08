#################### /eks_cluster.tf
#################### for DEV_EKS
resource "aws_eks_cluster" "EKS_cluster" {
  name     = "${var.project}-${var.TEAM}-eks"
  version  = "1.27"
  role_arn = aws_iam_role.EKS_role.arn
  vpc_config {
    subnet_ids = [data.terraform_remote_state.get_infra.outputs.pri_A_subnet_id[1], data.terraform_remote_state.get_infra.outputs.pri_C_subnet_id[1]]
    #subnet_ids = [var.pri_A_subnet_id[1], var.pri_C_subnet_id[1]]
  }
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.AmazonEBSCSIDriverPolicy,
  ]
  tags = {
    TYPE    = "${var.project}-${var.TYPE}"
  }
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.EKS_cluster.name
  addon_name   = "coredns"

  depends_on = [aws_eks_node_group.nodeg]
}

resource "aws_eks_addon" "kube-proxy" {
  cluster_name = aws_eks_cluster.EKS_cluster.name
  addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "vpc-cni" {
  cluster_name = aws_eks_cluster.EKS_cluster.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "efs-csi" {
  cluster_name = aws_eks_cluster.EKS_cluster.name
  addon_name   = "aws-efs-csi-driver"

  depends_on = [aws_eks_node_group.nodeg]
}