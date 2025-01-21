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
  source  = "terraform-aws-modules/eks/aws"
  version = "20.33.0"

  cluster_name    = "anatol-dev-eks-cluster"
  cluster_version = "1.31"
  vpc_id          = aws_vpc.anatol_dev_vpc.id
  subnet_ids      = aws_subnet.anatol_dev_subnet[*].id
  }

  managed_node_groups = {
    anatol_nodes = {
      desired_capacity = 2
      max_capacity     = 2
      min_capacity     = 2

      instance_type = "t3.micro"
    }
  }
}
