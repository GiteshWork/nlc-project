# lambda_code/image_processor.py
import json
import boto3
import os

# In a real project, you would add a database library like psycopg2
# For this demo, we'll simulate reading from the database.

secrets_manager = boto3.client('secretsmanager')
s3_client = boto3.client('s3')

def lambda_handler(event, context):
    # 1. Get database credentials from Secrets Manager (Demonstrates secrets management)
    secret_name = os.environ.get("DB_SECRET_NAME")
    try:
        secret_value = secrets_manager.get_secret_value(SecretId=secret_name)
        db_creds = json.loads(secret_value['SecretString'])
        # In a real app: db_connection = connect(user=db_creds['username'], ...)
        print("Successfully retrieved database credentials.")
    except Exception as e:
        print(f"Error retrieving secret: {e}")
        raise e

    # 2. Get the uploaded image details from the S3 trigger event
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    print(f"New image detected: {key} in bucket {bucket}")

    # 3. Simulate creating a thumbnail (In a real app, you'd use a library like Pillow)
    thumbnail_key = f"thumb-{key}"
    print(f"Simulating thumbnail creation for {thumbnail_key}")

    # 4. Return a success message
    return {
        'statusCode': 200,
        'body': json.dumps(f"Successfully processed {key} and created thumbnail {thumbnail_key}")
    }