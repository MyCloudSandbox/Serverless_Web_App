# This Terraform configuration file defines a DynamoDB table named "Reviews" with various attributes and global secondary indexes.
resource "aws_dynamodb_table" "reviews" {
  name           = "Reviews"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "reviewId"
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "reviewId"
    type = "S"
  }

  attribute {
    name = "bookTitle"
    type = "S"
  }

  attribute {
    name = "author"
    type = "S"
  }

  attribute {
    name = "reviewText"
    type = "S"
  }

  attribute {
    name = "rating"
    type = "N"
  }

  attribute {
    name = "createdAt"
    type = "S"
  }
  # Define global secondary indexes for the table
  global_secondary_index {
    name            = "BookTitleIndex"
    hash_key        = "bookTitle"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "AuthorIndex"
    hash_key        = "author"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "RatingIndex"
    hash_key        = "rating"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "CreatedAtIndex"
    hash_key        = "createdAt"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "reviewTextIndex"
    hash_key        = "reviewText"
    projection_type = "ALL"
  }

  tags = {
    Name = "ReviewsTable"
  }

  lifecycle {
    ignore_changes = [replica]
  }
}
# Define a replica for the DynamoDB table in another region
resource "aws_dynamodb_table_replica" "dynamic_table_replica" {
  provider         = aws.alt
  global_table_arn = aws_dynamodb_table.reviews.arn

  tags = {
    Name        = "dynamodb-table"
    Environment = "production"
  }
}