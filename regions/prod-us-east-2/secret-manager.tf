resource "aws_secretsmanager_secret" "db_pass" {
  name = "python-predictions-${var.region}-db"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db_pass_val" {
  secret_id     = aws_secretsmanager_secret.db_pass.id
  secret_string = <<EOF
  {
    "username": "${aws_db_instance.postgresdb.username}",
    "password": "${random_password.db_pass.result}",
    "engine": "${aws_db_instance.postgresdb.engine}",
    "host": "${aws_db_instance.postgresdb.address}",
    "port": "${aws_db_instance.postgresdb.port}",
    "dbClusterIdentifier": "python-predictions-${var.region}-${var.environment}-db"
  }
  EOF

  depends_on = [
    aws_db_instance.postgresdb
  ]
}