# This Terraform configuration file sets up an S3 bucket to host a React application, configures CloudFront for CDN, and manages public access.
resource "aws_s3_bucket" "react_app_bucket" {
  bucket_prefix = "my-react-app-bucket" # Replace with your desired bucket prefix

  # Use the "bucket_policy" resource to manage public access
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "react_app_bucket_public_access_block" {
  bucket = aws_s3_bucket.react_app_bucket.id

  block_public_acls   = false 
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "react_app_bucket_website" {
  bucket = aws_s3_bucket.react_app_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_object" "react_app_files" {
  for_each = fileset("${path.module}/build", "**")

  bucket = aws_s3_bucket.react_app_bucket.bucket
  key    = each.value
  source = "${path.module}/build/${each.value}"
  etag   = filemd5("${path.module}/build/${each.value}")
  
  content_type = lookup({
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript",
    "png"  = "image/png",
    "jpg"  = "image/jpeg",
    "jpeg" = "image/jpeg",
    "gif"  = "image/gif",
    "svg"  = "image/svg+xml"
  }, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream")
}

resource "aws_cloudfront_origin_access_identity" "react_app_identity" {
  comment = "OAI for React App"
}

resource "aws_s3_bucket_policy" "react_app_bucket_policy" {
  bucket = aws_s3_bucket.react_app_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          "AWS": "${aws_cloudfront_origin_access_identity.react_app_identity.iam_arn}"
        },
        Action = "s3:GetObject",
        Resource = "${aws_s3_bucket.react_app_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_cloudfront_distribution" "react_app_distribution" {
  origin {
    domain_name = aws_s3_bucket.react_app_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.react_app_bucket.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.react_app_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "React App CloudFront Distribution"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.react_app_bucket.id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all" # Allow both HTTP and HTTPS
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.react_app_distribution.domain_name
}


