import boto3
import requests
from warrant.aws_srp import AWSSRP
from aws_requests_auth.aws_auth import AWSRequestsAuth

region = 'us-east-1'
USERNAME="Rafiya"
PASSWORD="Rafiya123!"

POOL_ID='us-east-1_4uFlbieVB'
CLIENT_ID = "647fc0039e6ep4af9s0uforga5"
HOST = "https://rfrqhqy0wg.execute-api.us-east-1.amazonaws.com"
STAGE = "test/movies"
BASE_URL = f"{HOST}/{STAGE}"

cognito = boto3.client('cognito-idp', region)
# aws = AWSSRP(username=USERNAME, password=PASSWORD, pool_id=POOL_ID,
#              client_id=CLIENT_ID, pool_region=region)
# tokens = aws.authenticate_user()
# id_token = tokens['AuthenticationResult']['IdToken']
# access_token = tokens['AuthenticationResult']['AccessToken']
# print("ID token: ", id_token)

# print("--------------------------------------------------------------------------------------------------")
# print("--------------------------------------------------------------------------------------------------")
# print("Access token: ", access_token)

response = cognito.initiate_auth(AuthFlow='USER_PASSWORD_AUTH', AuthParameters={"USERNAME": USERNAME,
        "PASSWORD": PASSWORD}, ClientId = CLIENT_ID)

# store credentials
access_token = response['AuthenticationResult']['AccessToken']
print("Access token: ", access_token)

r1 = requests.get(f"{BASE_URL}", headers={"Authorization": access_token}) # the test call
print("API Response: ", r1.status_code, r1.reason)
print("API content: ", r1.content)
