#################### /eks_nodegroup.tf
#################### for DEV_EKS
resource "aws_eks_node_group" "nodeg" {
  cluster_name    = aws_eks_cluster.EKS_cluster.name
  node_group_name = "${var.project}-${var.TYPE}-node-group"
  node_role_arn   = aws_iam_role.node-role.arn
  #subnet_ids      = [var.pri_A_subnet_id[1], var.pri_C_subnet_id[1]]
  subnet_ids      = [data.terraform_remote_state.get_infra.outputs.pri_A_subnet_id[1], data.terraform_remote_state.get_infra.outputs.pri_C_subnet_id[1]]
  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 2
  }
  update_config {
    max_unavailable = 1
  }

  instance_types = ["m6i.xlarge"]

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
  tags = {
    TYPE    = "${var.project}-${var.TYPE}"
    TEAM    = "${var.TEAM}"
  }
}
