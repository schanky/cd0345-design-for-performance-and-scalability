# TODO: Define the output variable for the lambda function.
output "lambda_function_arn" {
  description = "Output value of Lambda function"
  value = "${aws_lambda_function.lambda_greeting.arn}"
}

#Add output for JSON rendered policy
output "rendered_policy" {
  value = data.aws_iam_policy_document.lambda_logging.json
}