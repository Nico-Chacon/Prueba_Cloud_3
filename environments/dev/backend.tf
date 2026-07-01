terraform {
  backend "s3" {
    bucket         = "chacon-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "chacon-terraform-locks"
    encrypt        = true
  }
}
