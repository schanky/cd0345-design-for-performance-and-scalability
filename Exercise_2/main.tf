#Define provider and credentials (stored locally)
provider "aws" {
    region = var.aws_region
    shared_credentials_files = [ "/Users/gene/.aws/credentials" ]
}

#Create lambda logging policy document
data "aws_iam_policy_document" "lambda_logging" {
  statement {
    sid = "1"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"  
    ]
    resources = [ "arn:aws:logs:*" ]
  }
}

#Create role logging policy document
data "aws_iam_policy_document" "role_logging_policy" {
    statement {
      effect = "Allow"
      principals {
        type = "Service"
        identifiers = [ "lambda.amazonaws.com" ]
      }
      actions = [ "sts:AssumeRole" ]
    }
}

#Create IAM logging Policy 
resource "aws_iam_policy" "lambda_logging" {
  name = "lambda_logging_policy"
  description = "This policy allows logging events from lambda functions"
  policy = data.aws_iam_policy_document.lambda_logging.json
}

#Create role to apply policy to
resource "aws_iam_role" "lambda_logger" {
  name = "iam_role_lambda"
  assume_role_policy = data.aws_iam_policy_document.role_logging_policy.json
}

#Create policy attachment to apply to role
resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role = aws_iam_role.lambda_logger.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

#Cloudwatch Log
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 30
}

#ZIP file for Lambda consumption
data "archive_file" "lambda_function_zip" {
  type = "zip"
  source_file = "${path.module}/greet_lambda.py"
  output_path = "${path.module}/function_payload.zip"
}

#Create funtion
resource "aws_lambda_function" "lambda_greeting" {
  description = "A Lambda function issuing a greeting."
  role = aws_iam_role.lambda_logger.arn
  filename = "function_payload.zip"
  source_code_hash = data.archive_file.lambda_function_zip.output_base64sha256
  function_name = var.lambda_name
  handler = "${var.lambda_name}.lambda_handler"
  runtime = "python3.8"

  environment {
    variables = {
      greeting = "Hello World!"
    }
  }

  depends_on = [ aws_cloudwatch_log_group.lambda_log_group, aws_iam_role_policy_attachment.lambda_logging ]
}




