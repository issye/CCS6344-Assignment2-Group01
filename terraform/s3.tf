# --- 1. Create a Random ID ---
# S3 Bucket names must be unique across the WHOLE WORLD. 
# This tool creates a random string (like "bucket-x9z2") so your name is unique.
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# --- 2. Create the Bucket ---
resource "aws_s3_bucket" "secure_storage" {
  # This makes the name something like "student-records-storage-a1b2c3d4"
  bucket = "student-records-storage-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "Secure Student Records"
    Environment = "Production"
  }
}

# --- 3. Enable Versioning (Recovery Risk) ---
# If a hacker (or clumsy admin) deletes a file, we can "undelete" it.
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.secure_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

# --- 4. Enable Encryption (Data Protection Risk) ---
# This forces AWS to encrypt every file automatically.
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.secure_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # Standard strong encryption
    }
  }
}

# --- 5. Block Public Access (Network Risk) ---
# This ensures no one on the internet can just "guess" the URL and see files.
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.secure_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
