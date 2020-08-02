# Set up backend to store .tfstate file
# https://www.terraform.io/docs/backends/types/index.html
# https://www.terraform.io/docs/backends/types/s3.html

terraform {
  required_version = "~> 0.12"
  backend "s3" {
    encrypt = true
    bucket  = "joes-tf-state-encrypted"
    key     = "prod/foo-app/terraform.tfstate"
    region  = "ap-southeast-2"
  }
}

