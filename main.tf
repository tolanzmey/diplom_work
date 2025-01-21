# Create a new directory for the project and initialize the Terraform configuration
.
├── main.tf          # Main terraform configuration
├── variables.tf      # Input variables
├── outputs.tf        # Output values
├── backend.tf        # Backend configuration for storing the state file
├── ci_pipeline.yaml  # CI/CD pipeline configuration for automatic deployment

# main.tf
provider "aws" {
  region = var.region
}

resource "aws_vpc" "anatol_dev_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "anatol-dev-vpc"
  }
}

resource "aws_subnet" "anatol_dev_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.anatol_dev_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "anatol-dev-subnet-${count.index}"
  }
}

resource "aws_ecr_repository" "anatol_dev_repo" {
  name = "anatol-dev-ecr-repo"
}

module "anatol_eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "anatol-dev-eks-cluster"
  cluster_version = "1.24"
  subnets         = aws_subnet.anatol_dev_subnet[*].id
  vpc_id          = aws_vpc.anatol_dev_vpc.id

  node_groups = {
    anatol_dev_nodes = {
      desired_capacity = 2
      max_capacity     = 2
      min_capacity     = 2

      instance_type = "t3.micro"
    }
  }
}
