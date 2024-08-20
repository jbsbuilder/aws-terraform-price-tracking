import json
import boto3
import base64
import uuid
import os
from datetime import datetime

textract = boto3.client('textract')
dynamobd = boto3.client('dynamodb')

Dynamo_talbe_name = os.environ['TABLE_NAME']

def lambda_handler(event, context):
    try:
        content_type = event['headers'].get('Content-Type') or event['headers'].get('content-type')
        if content_type.startswith('multipart/form-data'):
            boundary = content_type.split('=')[1]
            body = event['body']
            file_content = base64.b64decode(body.split(body.split('\r\n\r\n')[1].rsplit('\r\n')[0])
        else:
            file_content = based64.b64decode(event['body'])

        response = textract.analyze_expense(
            Document={'Bytes': file_content}
        )

        table = dynamodb.Table(Dynamo_table_name)
        expense_id = str(uuid.uuid4())
        expense = []

        for document in response['ExpenseDocuments']:
            for field in document['SummaryFields']:
                expense_item = {
                    'ExpenseID': expense_id,
                    'Timestamp': datetime.utcnow().isoformat(),
                    'Type': field['Type']['Text'],
                    'Value': field['ValueDetection']['Text']
                }
                expensese.append(expense_item)

        with table.batch_writer() as batch:
            for expense in expenses:
                batch.put_item(Item=expense)

        return {
                'statusCode': 200,
                'body': json.dumps({
                    'status': 'success',
                    'message': f'Expenses stored with ExpenseId {expense_id}'
                })
            }

        except Exception as e:
            return {
                    'statusCode': 500,
                    'body': json.dumps({
                        'status': 'error',
                        'message': str(e)
                    })
                }
