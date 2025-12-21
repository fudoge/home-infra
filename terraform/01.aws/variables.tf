
variable "vw_backup_bucket_name" {
  description = "S3 bucket for Vaultwarden backup"
  type        = string
}

variable "notification_email" {
  description = "Email address for SNS notification"
  type        = string
}
