import boto3

# Initialize AWS S3 client
s3 = boto3.client('s3')

# Desired state: All buckets must have server-side encryption enabled
desired_state = True

# Fetch all S3 buckets
buckets = s3.list_buckets()['Buckets']

for bucket in buckets:
    bucket_name = bucket['Name']
    try:
        enc = s3.get_bucket_encryption(Bucket=bucket_name)
        status = True
    except s3.exceptions.ClientError:
        status = False

    if status != desired_state:
        print(f"DRIFT DETECTED: Bucket '{bucket_name}' encryption is not enabled!")
