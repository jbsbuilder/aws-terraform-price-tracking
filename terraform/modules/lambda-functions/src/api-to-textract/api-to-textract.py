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
