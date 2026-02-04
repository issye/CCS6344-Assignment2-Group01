locals {
  app_port = 5000
}

resource "aws_instance" "flask_app_a" {
  ami                         = "ami-0c02fb55956c7d316"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.private_app.id
  vpc_security_group_ids      = [aws_security_group.app_instance_sg.id]
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y git python3
    pip3 install -r /home/ec2-user/app/requirements.txt || true

    # Example deployment (pick ONE approach)
    # Approach A: git clone your repo
    cd /home/ec2-user
    git clone https://github.com/YOUR_ORG/YOUR_REPO.git app

    cd /home/ec2-user/app
    pip3 install -r requirements.txt

    export DB_HOST="${aws_db_instance.default.address}"
    export DB_USER="admin"
    export DB_PASSWORD="${aws_db_instance.default.password}"
    export DB_NAME="studentdb"

    nohup python3 app.py &
  EOF

  tags = { Name = "FlaskApp-A" }
}

resource "aws_instance" "flask_app_b" {
  ami                         = "ami-0c02fb55956c7d316"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.private_app_2.id
  vpc_security_group_ids      = [aws_security_group.app_instance_sg.id]
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

  user_data = aws_instance.flask_app_a.user_data
  tags = { Name = "FlaskApp-B" }
}

resource "aws_lb_target_group_attachment" "attach_a" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.flask_app_a.id
  port             = local.app_port
}

resource "aws_lb_target_group_attachment" "attach_b" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.flask_app_b.id
  port             = local.app_port
}
