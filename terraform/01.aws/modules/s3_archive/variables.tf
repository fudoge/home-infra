variable "backup_bucket_name" {
  description = "Backup Bucket Name"
  type        = string
}
variable "transition_days_to_archive" {
  description = "Transition days to Glacier Deep Archive"
  type        = number
}
variable "expiration_days" {
  description = "Days to expire"
  type        = number
}
variable "backup_users" {
  description = "List of Backup Users to permit Put Object"
  type        = list(string)
}
