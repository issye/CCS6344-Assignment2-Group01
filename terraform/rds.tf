# --- 1. Create a Second Private Room (Required for Databases) ---
# AWS Databases need at least 2 Availability Zones to work.
resource "aws_subnet" "private_db_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"  # Different zone than Issye's (which is 1a)

  tags = {
    Name = "private-db-subnet-2"
  }
}

# --- 2. Group the Private Rooms Together ---
# This tells AWS: "The database can live in either Room 1 or Room 2"
resource "aws_db_subnet_group" "db_group" {
  name       = "main-db-subnet-group"
  subnet_ids = [aws_subnet.private_db_1.id, aws_subnet.private_db_2.id]
}

resource "aws_db_instance" "default" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "studentdb"
  username               = "admin"
  password               = "SecurePass123!"     # (optional improvement: random_password)
  skip_final_snapshot    = true

  db_subnet_group_name   = aws_db_subnet_group.db_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  storage_encrypted      = true
  multi_az               = true
}


# --- 3. Create the Secure Database ---
resource "aws_db_instance" "default" {
  # Hardware Settings
  allocated_storage    = 20             # 20 GB of space
  engine               = "mysql"        # We are using MySQL
  engine_version       = "8.0"          # Version 8.0
  instance_class       = "db.t3.micro"  # The smallest/cheapest computer
  
  # Identity Settings
  db_name              = "studentdb"    # The name of our database
  username             = "admin"        # The master username
  password             = "SecurePass123!" 
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true           # Don't take a backup when we delete it (saves time for labs)

 
  
  # 1. Network Security: Put it in the private subnets
  db_subnet_group_name   = aws_db_subnet_group.db_group.name
  
  # 2. Firewall: Attach the Security Group Issye made
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  # 3. Encryption: Lock the data so thieves can't read it
  storage_encrypted      = true 
  
  # 4. Availability: Create a standby copy in the second room (Risk Mitigation)
  multi_az               = true
}
