terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.28.0"
    }
  }
  backend "s3" {
      bucket = "python-predictions-terraform-state"
      key = "state/terraform.tfstate"
      dynamodb_table = "python-predictions-terraform-state"
      region = "us-east-2" 
      role_arn = "arn:aws:iam::294622776641:role/python-predictions-infrastructure-management-role"
  }
}

module "prod-us-east-2" {
  source  = "./regions/prod-us-east-2/"
  assume_role_name = var.us_east_2_assume_role
  region = "us-east-2"
  postgres_db_size = "db.t3.small"
  postgres_db_name = "python_predictions_db"
  postgres_db_username = "root"
  postgres_db_identifier = "python-predictions-db"
  python_flask_app_size = "t3.small"
}