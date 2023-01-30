resource "aws_db_subnet_group" "main" {
  name       = "python-prediction-${var.region}-${var.environment}-db-subnet-group"
  subnet_ids = [aws_subnet.main_private_a.id,aws_subnet.main_private_b.id,aws_subnet.main_private_c.id]
  description = "python prediction rds subnet group"

  tags = {
    Name = "python-prediction-${var.region}-${var.environment}-subnet-group"
    Environment = var.environment 
  }
}

 resource "random_password" "db_pass" {
   length            = 20
   special           = false
 }

resource "aws_db_instance" "postgresdb" {
  instance_class      = var.postgres_db_size
  identifier          = var.postgres_db_identifier
  multi_az                          = false
  port                              = 5432
  engine                            = "postgres"
  engine_version                    = "13.4"
  db_name                           = var.postgres_db_name
  username                          = var.postgres_db_username
  password                          = random_password.db_pass.result
  vpc_security_group_ids            = [aws_security_group.postgres_db.id]
  deletion_protection               = false
  storage_type                      = "gp2" 
  performance_insights_enabled      = true
  publicly_accessible               = false
  delete_automated_backups          = true 
  auto_minor_version_upgrade        = false
  apply_immediately                 = false
  backup_retention_period           = 7
  backup_window                     = "09:00-00:16" #utc time
  allow_major_version_upgrade       = false 
  db_subnet_group_name              = aws_db_subnet_group.main.name
  maintenance_window                = "tue:06:30-tue:07:30"
  skip_final_snapshot               = true
  storage_encrypted = true
  allocated_storage = 20

  depends_on = [
    aws_db_subnet_group.main
  ]

  tags = {
    Name = "python-predictions-${var.region}-${var.environment}-database",
    Environment = var.environment
  }  
}
