data "aws_caller_identity" "current" {}

#data "aws_elastic_beanstalk_solution_stack" "multi_docker" {
#  most_recent = true
#
#  name_regex = "^64bit Amazon Linux (.*) Multi-container Docker (.*)$"
#}

data "aws_vpc" "main" {
  id = aws_vpc.vpc_main.id
  depends_on = [
    aws_vpc.vpc_main
  ]    
}
