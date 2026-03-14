
resource "random_string" "bootstrap_bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "remote_backend_bucket" {
  bucket = "test-remote-backend-${random_string.bootstrap_bucket_suffix.result}"

  tags = var.bucket_tags
}
