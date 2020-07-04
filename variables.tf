# main creds for AWS connection 
# Don't do this. These creds are invalid and wont work
# I'm doing this to test if it will be picked up by the static analysis
variable "aws_access_key_id" {
  description = "AWS access key"
  default = "AKIAAOEVE2QMK6A4JZZM"
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
  default = "Wh5ZNFWhn52EShu+HA2Jm6shMmJm3nw5ZbglpHxw"
}