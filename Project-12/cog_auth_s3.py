from warrant.aws_srp import AWSSRP
import boto3
import os

region = 'us-east-1'
USERNAME="Rafiya"
PASSWORD="Rafiya123!"
USER_POOL_ID='us-east-1_vtM4Zq2Dr'
CLIENT_ID = "7iovvrcjb8fopqd41c9kndl99n"
IDENTITY_POOL_ID = "us-east-1:756b90de-deca-40d4-8978-bccaf967ee4e"
PROVIDER = f'cognito-idp.us-east-1.amazonaws.com/{USER_POOL_ID}'
BUCKET_NAME = "tcf30-testbucket"
upload_filename_path = "file.txt"

aws = AWSSRP(username=USERNAME, password=PASSWORD, pool_id=USER_POOL_ID,
             client_id=CLIENT_ID)
tokens = aws.authenticate_user()
id_token = tokens['AuthenticationResult']['IdToken']
print("ID token: ", id_token)
print("--------------------------------------------------------------------------------------------------")
print("--------------------------------------------------------------------------------------------------")

client = boto3.client('cognito-identity', region)

## get_id() returns a unique identifier (Id of the user in the Identity pool). Logins parameter maps provider names to provider tokens
identity_response = client.get_id(
        IdentityPoolId=IDENTITY_POOL_ID,
        Logins={PROVIDER : id_token}
    )

identity_id = identity_response['IdentityId']

print("Identity Id: ", identity_id)

## get_credentials_for_identity() - Returns temporary credentials for the provided identity ID.
aws_cred = client.get_credentials_for_identity(
        IdentityId=identity_id,
        Logins={PROVIDER : id_token}
    )

access_key = aws_cred ['Credentials']['AccessKeyId']
secret_key = aws_cred ['Credentials']['SecretKey']
session_token = aws_cred ['Credentials']['SessionToken']

print("AWS Access key: ", access_key)
print("AWS Secret key: ", secret_key)
print("AWS Session token: ", session_token)
print("--------------------------------------------------------------------------------------------------")
print("--------------------------------------------------------------------------------------------------")

## uploads a file to s3 bucket using temporary credentials
def put_file(access_key, secret_key, region, session_token,
              identity_id, bucket_name, upload_filename_path):
   filename = os.path.basename(upload_filename_path) 
   key_name = f"{identity_id}/{filename}"
   metadata = {}
   s3client = boto3.client(
    's3',
    region,
    aws_access_key_id=access_key,
    aws_secret_access_key=secret_key,
    aws_session_token=session_token
    )
   s3transfer = boto3.s3.transfer.S3Transfer(s3client)    
   s3transfer.upload_file(upload_filename_path, bucket_name,
                  key_name, extra_args={'Metadata': metadata})
   return

## call the above function to upload a file in foldername (identified by user’s identity_id) in the private s3 bucket
put_file(access_key, secret_key, region, session_token, identity_id, BUCKET_NAME, upload_filename_path)
print("Successfully uploaded file to S3.")

## Try to change the identity_id. This will show an authentication error
#put_file(access_key, secret_key, region, session_token, "us-east-1:a76dvg67–9434-ghiy-9iou-cd1hh7d30ba1", BUCKET_NAME, upload_filename_path)