import json
import boto3

query = 'SELECT id,name,size FROM default_task3_curated limit 10;'
DATABASE = 'task3-curated'
output='s3://default-task3-use-case-a'

def lambda_handler(event, context):
    client = boto3.client('athena')
    # Execution
    response = client.start_query_execution(
        QueryString=query,
        QueryExecutionContext={
            'Database': DATABASE
        },
        ResultConfiguration={
            'OutputLocation': output,
        }
    )
    return response
