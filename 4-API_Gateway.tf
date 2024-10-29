# This Terraform configuration file sets up an AWS API Gateway for managing book reviews.
resource "aws_api_gateway_rest_api" "reviews_api" {
  name        = "ReviewsAPI"
  description = "API for managing book reviews"
}

resource "aws_api_gateway_resource" "reviews_resource" {
  rest_api_id = aws_api_gateway_rest_api.reviews_api.id
  parent_id   = aws_api_gateway_rest_api.reviews_api.root_resource_id
  path_part   = "reviews"
}

resource "aws_api_gateway_method" "post_reviews_method" {
  rest_api_id   = aws_api_gateway_rest_api.reviews_api.id
  resource_id   = aws_api_gateway_resource.reviews_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_reviews_integration" {
  rest_api_id             = aws_api_gateway_rest_api.reviews_api.id
  resource_id             = aws_api_gateway_resource.reviews_resource.id
  http_method             = aws_api_gateway_method.post_reviews_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.create_review.invoke_arn
}

resource "aws_api_gateway_method" "get_reviews_method" {
  rest_api_id   = aws_api_gateway_rest_api.reviews_api.id
  resource_id   = aws_api_gateway_resource.reviews_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_reviews_integration" {
  rest_api_id             = aws_api_gateway_rest_api.reviews_api.id
  resource_id             = aws_api_gateway_resource.reviews_resource.id
  http_method             = aws_api_gateway_method.get_reviews_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "GET"
  uri                     = aws_lambda_function.get_reviews.invoke_arn
}

resource "aws_api_gateway_resource" "review_id_resource" {
  rest_api_id = aws_api_gateway_rest_api.reviews_api.id
  parent_id   = aws_api_gateway_resource.reviews_resource.id
  path_part   = "{reviewId}"
}

resource "aws_api_gateway_method" "put_review_method" {
  rest_api_id   = aws_api_gateway_rest_api.reviews_api.id
  resource_id   = aws_api_gateway_resource.review_id_resource.id
  http_method   = "PUT"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "put_review_integration" {
  rest_api_id             = aws_api_gateway_rest_api.reviews_api.id
  resource_id             = aws_api_gateway_resource.review_id_resource.id
  http_method             = aws_api_gateway_method.put_review_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "PUT"
  uri                     = aws_lambda_function.update_review.invoke_arn
}

resource "aws_api_gateway_method" "delete_review_method" {
  rest_api_id   = aws_api_gateway_rest_api.reviews_api.id
  resource_id   = aws_api_gateway_resource.review_id_resource.id
  http_method   = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "delete_review_integration" {
  rest_api_id             = aws_api_gateway_rest_api.reviews_api.id
  resource_id             = aws_api_gateway_resource.review_id_resource.id
  http_method             = aws_api_gateway_method.delete_review_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "DELETE"
  uri                     = aws_lambda_function.delete_review.invoke_arn
}

resource "aws_api_gateway_deployment" "reviews_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.post_reviews_integration,
    aws_api_gateway_integration.get_reviews_integration,
    aws_api_gateway_integration.put_review_integration,
    aws_api_gateway_integration.delete_review_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.reviews_api.id
  stage_name  = "prod"
}

output "api_gateway_url" {
  value       = aws_api_gateway_deployment.reviews_api_deployment.invoke_url
  description = "The URL of the API Gateway"
}