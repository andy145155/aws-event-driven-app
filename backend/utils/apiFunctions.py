try:
    import unzip_requirements
except ImportError:
    pass
from utils.constants import REGION_NAME, RDS_SECRET_NAME, S3_BUCKET_NAME, SSL_FILE_NAME
import boto3
import sqlalchemy
from botocore.exceptions import ClientError
from io import StringIO
import pandas as pd
import json
import os
from urllib.parse import quote_plus


# Retrieve csv from SQS message that contains S3 trigger event
def getCsvFromSQS(event):

    try:
        # Get bucket, key from S3 trigger event
        sqsMessage = json.loads(event['Records'][0]['body'])
        bucket = sqsMessage['Records'][0]['s3']['bucket']['name']
        key = sqsMessage['Records'][0]['s3']['object']['key']
        csv_data = getObjectFromS3(bucket, key)
        df_csv_data = pd.read_csv(StringIO(csv_data))
        return key, df_csv_data
    except ClientError as error:
        print("Error retrieving csv from S3 trigger event: %s" % (error))


# Retrieve object from S3 with bucket name and object key
def getObjectFromS3(bucket, key):

    # Create S3 bucket client
    s3 = boto3.client('s3', region_name=REGION_NAME)

    try:
        s3_object = s3.get_object(Bucket=bucket, Key=key)
        data = s3_object['Body'].read().decode('utf-8')
        return data
    except ClientError as error:
        print("Error retrieving object from S3 bucker: %s" % (error))


# Get RDS SSL file from S3
def getRdsSSLCert():

    # Create S3 bucket client
    s3 = boto3.client('s3', region_name=REGION_NAME)
    try:
        ssl_object = s3.get_object(
            Bucket=S3_BUCKET_NAME["SSL_BUCKET"], Key=SSL_FILE_NAME)
        data = ssl_object['Body'].read().decode('utf-8')
        return saveToLocalDirectory(data)
    except ClientError as error:
        print(
            f"""Error getting RDS SSL certificate from {S3_BUCKET_NAME["SSL_BUCKET"]}: {error}""")


def getRdsIamConnection(secret):

    # Create a RDS client
    rds = boto3.client('rds', region_name=REGION_NAME)

    db_host = secret['DB_HOST']
    db_port = secret['DB_PORT']
    db_name = secret['DB_NAME']
    db_user = secret['DB_IAM_USER']

    print('Connecting to {}'.format(secret['DB_HOST']))
    try:
        # Generate Iam authentication token
        db_auth_token = rds.generate_db_auth_token(
            db_host, db_port, db_user, REGION_NAME)
        ssl_cert = getRdsSSLCert()
        os.environ['LIBMYSQL_ENABLE_CLEARTEXT_PLUGIN'] = '1'
        engineURL = f"""mysql+pymysql://{db_user}:{quote_plus(db_auth_token)}@{db_host}:{db_port}/{db_name}?charset=utf8mb4"""
        # IAM database authentication with SSL connection
        engine = sqlalchemy.create_engine(
            engineURL,
            connect_args={'ssl_ca': ssl_cert}
        )
        return engine
    except ClientError as error:
        print("Error connecting rds with IAM authentication: %s" % (error))


# Retrieve rds secrets from secrets manager
def getRdsSecrets():

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=REGION_NAME
    )

    try:
        secret_response = client.get_secret_value(
            SecretId=RDS_SECRET_NAME
        )
        return json.loads(secret_response['SecretString'])

    except ClientError as error:
        if error.response['Error']['Code'] == 'DecryptionFailureException':
            # Secrets Manager can't decrypt the protected secret text using the provided KMS key.
            raise error
        elif error.response['Error']['Code'] == 'InternalServiceErrorException':
            # An error occurred on the server side.
            raise error
        elif error.response['Error']['Code'] == 'InvalidParameterException':
            # You provided an invalid value for a parameter.
            raise error
        elif error.response['Error']['Code'] == 'InvalidRequestException':
            # You provided a parameter value that is not valid for the current state of the resource.
            raise error
        elif error.response['Error']['Code'] == 'ResourceNotFoundException':
            # We can't find the resource that you asked for.
            raise error


# This function will take RDS SSL pem file got from S3
# and save it into lambda's local file: /tmp/credentials/ap-southeast-1-bundle.pem
def saveToLocalDirectory(ssl_data):
    # Change directory to /tmp folder
    os.chdir('/tmp')

    # Make credentials directory
    if not os.path.exists(os.path.join('credentials')):
        os.makedirs('credentials')

    try:
        # Create ap-southeast-1-bundle.pem file
        rds_ssl_cert = open(f"credentials/{SSL_FILE_NAME}", "w")

        # Write data retrieved from s3 to ap-southeast-1-bundle.pem file
        rds_ssl_cert.write(ssl_data)

        rds_ssl_cert.close()
        return os.path.abspath(f"credentials/{SSL_FILE_NAME}")
    except Exception as error:
        print("Error downloading rds ssl package: %s" % (error))
