module "my_bucket" {
  source      = "./modules/simple_s3"
  bucket_name = "my-test-bucket-12345"
}