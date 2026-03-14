variable "bucket_tags" {
  type = map(string)
  default = {
    "name" = "remote_bucket"
  }
}