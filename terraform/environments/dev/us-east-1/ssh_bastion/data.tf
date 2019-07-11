data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket         = "terraform-state.your-org.tld"
    key            = "vpc"
    region         = "us-east-1"
    dynamodb_table = "terraform_lock"
  }
}
