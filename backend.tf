terraform {
  backend "s3" {
    bucket = "mramzan-terraform-s3"
    key    = "state"
    region = "us-west-2"
    dynamodb_table = "terraform-mramzan"
  }
}