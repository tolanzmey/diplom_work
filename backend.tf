terraform {
  backend "s3" {
    bucket         = "anatol-terraform-state-bucket"
    key            = "anatol/dev/eks-cluster/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "anatol-terraform-lock"
    encrypt        = true
  }
}
