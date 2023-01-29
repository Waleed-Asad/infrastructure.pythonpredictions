provider "aws" {
  assume_role {
      role_arn = var.assume_role_name
  }
  region = var.region
}