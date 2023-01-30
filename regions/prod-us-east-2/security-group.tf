resource "aws_security_group" "postgres_db" {
  name = "python-predictions-rds-sg"
  vpc_id = aws_vpc.vpc_main.id
  description = "Python Predictions RDS SG"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.python_flask_app_beanstalk.id]
    description = "Python Flask App"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "python-predictions-rds-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "python_flask_app_beanstalk" {
  name = "python_flask_app_beanstalk"
  vpc_id = aws_vpc.vpc_main.id
  description = "Python Flask App SG"

  ingress {
    security_groups = [aws_security_group.python_flask_app_beanstalk_alb.id]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "Python Flask App Beanstalk ALB SG"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "python-predictions-rds-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "python_flask_app_beanstalk_alb" {
  name = "python_flask_app_beanstalk_alb-sg"
  vpc_id = aws_vpc.vpc_main.id
  description = "Python Flask App Beanstalk ALB SG"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["94.107.192./32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["39.57.223.126/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "python_flask_app_beanstalk_alb-sg"
  }
}