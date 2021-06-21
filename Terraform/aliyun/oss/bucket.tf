resource "alicloud_oss_bucket" "terraform_oss_bucket" {
  bucket = var.aliyun_oss_bucket_name
  acl    = "private"
}