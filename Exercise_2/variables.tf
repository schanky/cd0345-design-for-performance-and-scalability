# TODO: Define the variable for aws_region
variable "aws_region" {
  type = string
  description = "AWS deployment region"
  default = "us-east-1"
}

variable "lambda_name" {
  type = string
  description = "Lambda Function name"
  default = "greet_lambda"
}