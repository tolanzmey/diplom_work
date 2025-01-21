variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

# outputs.tf
output "anatol_vpc_id" {
  value = aws_vpc.anatol_dev_vpc.id
}

output "anatol_subnet_ids" {
  value = aws_subnet.anatol_dev_subnet[*].id
}

output "anatol_eks_cluster_id" {
  value = module.anatol_eks.cluster_id
}

output "anatol_ecr_repository_url" {
  value = aws_ecr_repository.anatol_dev_repo.repository_url
}
