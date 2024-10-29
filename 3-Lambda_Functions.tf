# Define IAM role for Lambda functions
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policy to the IAM role
resource "aws_lambda_function" "create_review" {
  filename         = "${path.module}/create_review.zip" # Path to the zip file containing the Lambda function code
  function_name    = "CreateReviewFunction"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "create_review.handler"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256("${path.module}/create_review.zip") # Hash of the source code for versioning

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.reviews.name
    }
  }
}
# Define the DynamoDB table for reviews
resource "aws_lambda_function" "get_reviews" {
  filename         = "${path.module}/get_reviews.zip"
  function_name    = "GetReviewsFunction"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "get_reviews.handler"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256("${path.module}/get_reviews.zip")

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.reviews.name
    }
  }
}

resource "aws_lambda_function" "update_review" {
  filename         = "${path.module}/update_review.zip"
  function_name    = "UpdateReviewFunction"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "update_review.handler"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256("${path.module}/update_review.zip")

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.reviews.name
    }
  } 
}

resource "aws_lambda_function" "delete_review" {
  filename         = "${path.module}/delete_review.zip"
  function_name    = "DeleteReviewFunction"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "delete_review.handler"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256("${path.module}/delete_review.zip")

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.reviews.name
    }
  }
}