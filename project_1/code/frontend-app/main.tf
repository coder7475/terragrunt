# Random string resource to create a unique bucket name for testing the remote backend
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Simple test resource to verify remote backend
resource "aws_s3_bucket" "test_backend" {
  bucket = "test-remote-backend-${random_string.bucket_suffix.result}"

  tags = {
    Name        = "Test Backend Bucket"
    Environment = "dev"
  }
}