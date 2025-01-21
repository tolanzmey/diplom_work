provider "aws" {
  region = var.region
}

resource "aws_vpc" "dev_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "dev-vpc"
  }
}

resource "aws_subnet" "dev_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "dev-subnet-${count.index}"
  }
}

resource "aws_ecr_repository" "dev_repo" {
  name = "dev-ecr-repo"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "dev-eks-cluster"
  cluster_version = "1.24"
  subnets         = aws_subnet.dev_subnet[*].id
  vpc_id          = aws_vpc.dev_vpc.id

  node_groups = {
    dev_nodes = {
      desired_capacity = 2
      max_capacity     = 2
      min_capacity     = 2

      instance_type = "t3.micro"
    }
  }
}
