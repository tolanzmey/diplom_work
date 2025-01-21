terraform {
  backend "s3" {
    bucket         = "anatol-my-terraform-state-bucket"
    key            = "anatol-dev/eks-cluster/terraform.tfstate"
    region         = var.region
    dynamodb_table = "anatol-terraform-lock"
    encrypt        = true
  }
}
