# --- 1. Security Group for EC2 ---
resource "aws_security_group" "app_instance_sg" {
  name   = "app-instance-sg"
  vpc_id = aws_vpc.main.id

  # Allow inbound only from ALB
  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Allow outbound to anywhere (for updates, API calls)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- 2. IAM Role for EC2 (optional if using Secrets Manager) ---
resource "aws_iam_role" "ec2_role" {
  name = "ec2-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policy to allow fetching secrets (optional)
resource "aws_iam_role_policy_attachment" "secrets_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

# --- 3. EC2 Instance ---
resource "aws_instance" "flask_app" {
  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2 in us-east-1
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_app.id
  vpc_security_group_ids = [aws_security_group.app_instance_sg.id]
  associate_public_ip_address = false
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "FlaskAppInstance"
  }

  # User data script installs Python, Flask, and app
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install python3.9 -y
              pip3 install flask mysql-connector-python
              
              # Example: download app from S3 or clone Git repo
              # mkdir /home/ec2-user/app
              # cd /home/ec2-user/app
              # aws s3 cp s3://my-bucket/app.zip .
              # unzip app.zip
              
              # Run Flask app (for demo purposes)
              nohup python3 /home/ec2-user/app/app.py &
              EOF
}

# --- 4. IAM Instance Profile (for EC2 Role) ---
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-app-profile"
  role = aws_iam_role.ec2_role.name
}

# --- 5. Attach EC2 to Target Group ---
resource "aws_lb_target_group_attachment" "app_attachment" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.flask_app.id
  port             = 5000
}
