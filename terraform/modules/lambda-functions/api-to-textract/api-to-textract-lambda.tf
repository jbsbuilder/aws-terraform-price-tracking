data "achrive_file" "api-to-textract-lambda" {
	type = "zip"
source_dir = "${path.module}/src/api-to-textract-lambda.py"
output_path = "${path.module}/dist/api-to-textract-lambda.zip"
}

resource "aws_lambda_function" "api-to-textract-lambda" {
	filename = data.archive_file.api_to_textract_lambda.output_path
	function_name = "api-to-textract-lambda"
	role =	aws_iam_role.lambda_sample.arn
	handler = "main.lambda_handler"
	
	source_code_hash = data.archive_file.api_to_textract_lambda.output_base64sha256

	runtime = "python3.12"

	tracing_config {
		mode = "Active"
	}

	timeout = 30
	resreved_concurrent_executions = 50
	publish = true
}

resource "aws_lambda_permission" "api-to-textract-permission" {
	statement_id = "AllowAPIGateway-to-textract-lambda"
	action = "lambda:InvokeFunctino"
	function_name = aws_lambda_function.api-to-textract-lambda.arn
	principal = "apigateway.amazonaws.com"
	source_arn = "${var.api_gateway_api-to-textract-lambda_execution_arn}/dist/api-to-textract-lambda.zip"
}	
