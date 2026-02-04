resource "aws_iam_role" "ec2_role" {
  name = "ec2-app-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "ec2_least_priv" {
  name = "ec2-least-priv"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Allow EC2 to read app artifacts from the one bucket only (if you use S3 deploy)
      {
        Effect = "Allow",
        Action = ["s3:GetObject", "s3:ListBucket"],
        Resource = [
          aws_s3_bucket.secure_storage.arn,
          "${aws_s3_bucket.secure_storage.arn}/*"
        ]
      },
      # CloudWatch Logs (so you can show basic monitoring)
      {
        Effect = "Allow",
        Action = ["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents","logs:DescribeLogStreams"],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_least_priv" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_least_priv.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-app-profile"
  role = aws_iam_role.ec2_role.name
}
