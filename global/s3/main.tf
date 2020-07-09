# This blow block was added in after run for the first time 
# This then migrates the tfstate file to s3
terraform {
  backend "s3" {
    bucket         = "joes-tf-state-encrypted"
    key            = "global/s3/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "tf-app-state"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

# KMS Key to manage the tfstate encryption
resource "aws_kms_key" "terraform_key" {
  description             = "KMS key used to encrypt the tfstate bucket objects"
  deletion_window_in_days = 30 # 30 is the default
  enable_key_rotation     = true

  tags = {
    Name        = "tfStateKMSKey"
    Environment = "Production"
  }
}

# Create the S3 backend to hold the state file, with versioning and encryption!
# Remember bucket names are globaly unique
resource "aws_s3_bucket" "terraform_state" {
  bucket = "joes-tf-state-encrypted"
  acl    = "private" # this is default.. need to sort out for shared IAM (doing all this on root acc)
  
  #checkov:skip=CKV_AWS_18:Prod you _should_ enable logging for the tfstate (but I'm not)
  #checkov:skip=CKV_AWS_52:Prod you _should_ enable MFA delete Enabled (but I'm not)

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "tfstate"
    Environment = "Production"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.terraform_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

# Create the DynamoDB to ensure only 1 thing can update resources
# at a time.
resource "aws_dynamodb_table" "terraform_state_lock" {
  name = "tf-app-state"
  #checkov:skip=CKV_AWS_28:Prod you _should_ enable Dynamodb point in time recovery (backup) (but I'm not)

  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}