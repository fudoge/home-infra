bucket         = "riveroverflow-homeserver-backup"
key            = "aws/terraform.tfstate"
region         = "ap-northeast-2"
dynamodb_table = "homeserver-backup-locks"
encrypt        = true
