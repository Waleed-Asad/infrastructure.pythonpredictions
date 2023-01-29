variable "assume_role_name" { }
variable "region" { }
variable "environment" {
    description = "Environment name"
    default = "prod"
}

variable "postgres_db_size" { }
variable "postgres_db_name" {}
variable "postgres_db_username" {}
variable "postgres_db_identifier" {}
variable "python_flask_app_size" {}