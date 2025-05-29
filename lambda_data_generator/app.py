import json
import os
import boto3
import requests
from datetime import datetime

def handler(event, context):
    """
    Lambda function to collect data from an API and store it in S3
    """
    try:
        # Initialize AWS clients
        s3 = boto3.client('s3')
        
        # Get environment variables
        BUCKET_NAME = os.environ['BUCKET_NAME']
        API_ENDPOINT = os.environ['API_ENDPOINT']
        
        # Get current timestamp
        timestamp = datetime.now().strftime('%Y-%m-%d-%H-%M-%S')
        
        # Make API request
        response = requests.get(API_ENDPOINT)
        response.raise_for_status()
        data = response.json()
        
        # Prepare the data for storage
        file_content = json.dumps(data, indent=2)
        
        # Define the S3 key (path)
        s3_key = f'raw/api_data_{timestamp}.json'
        
        # Upload to S3
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=s3_key,
            Body=file_content,
            ContentType='application/json'
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Data successfully collected and stored',
                'timestamp': timestamp,
                'location': f's3://{BUCKET_NAME}/{s3_key}'
            })
        }
        
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': str(e)
            })
        } 