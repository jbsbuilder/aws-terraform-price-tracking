resource "aws_apigatewayv2_api" "api-gateway" {
  name          = "api-gateway"
  protocol_type = "HTTP"
}
