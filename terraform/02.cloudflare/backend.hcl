bucket         = "riveroverflow-homeserver-backup"
key            = "cloudflare/terraform.tfstate"
region         = "ap-northeast-2"
dynamodb_table = "homeserver-backup-locks"
encrypt        = true
