output "vpc_id" {
  value = aws_vpc.anatol_dev_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.anatol_dev_subnet[*].id
}

output "eks_cluster_id" {
  value = module.anatol_eks.cluster_id
}

output "ecr_repository_url" {
  value = aws_ecr_repository.anatol_dev_repo.repository_url
}
