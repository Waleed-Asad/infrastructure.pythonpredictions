output "vpc_main" {
  description = "The ID of the Main VPC"
  value       = aws_vpc.vpc_main.id
}

output "account_id" {
  description = "current account id"
  value       = data.aws_caller_identity.current.account_id
}