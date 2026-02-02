# --- 1. Create a Bucket specifically for Logs ---
resource "aws_s3_bucket" "log_bucket" {
  bucket_prefix = "security-logs-" # Adds a random number automatically
  force_destroy = true             # Allows deleting bucket even if full (for school labs)
}

# --- 2. The "Permission Slip" (Bucket Policy) ---
# This allows the CloudTrail service to write logs into the bucket above.
resource "aws_s3_bucket_policy" "log_bucket_policy" {
  bucket = aws_s3_bucket.log_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.log_bucket.arn
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.log_bucket.arn}/prefix/AWSLogs/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

# --- 3. The Security Camera (CloudTrail) ---
resource "aws_cloudtrail" "audit_log" {
  name                          = "management-events-trail"
  s3_bucket_name                = aws_s3_bucket.log_bucket.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true # Ensures logs haven't been tampered with
}
