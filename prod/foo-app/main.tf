# Set up backend to store .tfstate file
# https://www.terraform.io/docs/backends/types/index.html
# https://www.terraform.io/docs/backends/types/s3.html

terraform {
  required_version = "~> 0.12"
  backend "s3" {
    encrypt        = true
    dynamodb_table = "tf-app-state"
    bucket         = "joes-tf-state-encrypted"
    key            = "prod/foo-app/terraform.tfstate"
    region         = "ap-southeast-2"
  }
}

# TODO - ensure that secrets can only be access by roles that need them
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version
data "aws_secretsmanager_secret_version" "foo_token" {
  secret_id = var.foo_token_id
}

#TODO - how to ensure this is hidden in console output (esp for CI) 
output "foo_token" {
  value = data.aws_secretsmanager_secret_version.foo_token.secret_string
}
