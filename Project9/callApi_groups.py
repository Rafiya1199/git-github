import boto3
import requests
from warrant.aws_srp import AWSSRP
from aws_requests_auth.aws_auth import AWSRequestsAuth

region = 'us-east-1'
USERNAME="Rafiya"
PASSWORD="Rafiya123!"
# USERNAME="Shameem"
# PASSWORD="Shameem123!"
POOL_ID='us-east-1_ljg3xKczn'
CLIENT_ID = "1gv7v6ra3d0nkp9ko6eijuqbc8"
IDENTITY_POOL_ID = "us-east-1:fefe2a4e-463a-4738-b80e-c11a1c1f7026"
PROVIDER = f'cognito-idp.us-east-1.amazonaws.com/{POOL_ID}'
HOST = "https://94b4ajh88b.execute-api.us-east-1.amazonaws.com"
STAGE = "dev/shows"
BASE_URL = f"{HOST}/{STAGE}"
api_host="94b4ajh88b.execute-api.us-east-1.amazonaws.com"


aws = AWSSRP(username=USERNAME, password=PASSWORD, pool_id=POOL_ID,
             client_id=CLIENT_ID, pool_region=region)
tokens = aws.authenticate_user()
id_token = tokens['AuthenticationResult']['IdToken']
print("ID token: ", id_token)

print("----------------------------------------------------------------------------")

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


auth = AWSRequestsAuth(aws_access_key=access_key,
                       aws_secret_access_key=secret_key,
                       aws_token=session_token,
                       aws_host=api_host,
                       aws_region=region,
                       aws_service='execute-api')

## Call the API with temporary aws credentials

mymsg = {
    "senderEmail" : "rafiyafathima.11@gmail.com",
    "senderName": "rafiya",
    "senderPhoneNumber": "9566631068",
    "message": "Hello Good morning"
}

response = requests.post(f"{BASE_URL}", auth=auth, json = mymsg)
print("API Response: ", response.status_code, response.reason)
print("API content: ", response.content)