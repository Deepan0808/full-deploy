provider "aws" {
  region = "us-east-2"

}

variable "bucket_name" {
  default = "deploy-dpan"
}

resource "aws_s3_bucket" "s3" {
  bucket = var.bucket_name

}
