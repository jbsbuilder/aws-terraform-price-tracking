resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "ItemPrice"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserId"
  range_key      = "GameTitle"

  attribute {
    name = "VendorName"
    type = "S"
  }

  attribute {
    name = "ItemDescitption"
    type = "S"
  }

  attribute {
    name = "ItemPrice"
    type = "S"
  }

  attribute {
    name = "InvoiceReceiptID"
    type = "N"
  }

  attribute {
    name = "InvoiceDate"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }

  global_secondary_index {
    name               = "PriceIndexGSI"
    hash_key           = "ItemDesciption"
    range_key          = "ItemPrice"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["InvoiceDate", "InvoiceReceiptID"]
  }

  tags = {
    Name        = "PriceTrackingTable""
    Environment = "production"
  }
}
