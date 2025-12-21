variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "state_bucket_name" {
  description = "S3 bucket for Terraform state"
  type        = string
}

variable "state_dynamodb_table" {
  description = "DynamoDB table for state locking"
  type        = string
}

