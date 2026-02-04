resource "aws_db_subnet_group" "db_group" {
  name       = "main-db-subnet-group"
  subnet_ids = [aws_subnet.private_db_1.id, aws_subnet.private_db_2.id]

  tags = { Name = "db-subnet-group" }
}

resource "aws_db_instance" "default" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"

  db_name                = "studentdb"
  username               = "admin"
  password               = "SecurePass123!"
  skip_final_snapshot    = true

  db_subnet_group_name   = aws_db_subnet_group.db_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  storage_encrypted      = true
  multi_az               = true

  tags = { Name = "secure-studentdb" }
}
