import boto3
import requests


region = 'us-east-1'
cognito = boto3.client('cognito-idp', region)

clientId = 'XXXXXXXXXXXXXXXXXXXXX'
username = "aaliya"
password = "Aaliya123!"
HOST = "https://{api_id}.execute-api.us-east-1.amazonaws.com"
STAGE = "DEV/{proxy+}"
BASE_URL = f"{HOST}/{STAGE}"

response = cognito.initiate_auth(AuthFlow='USER_PASSWORD_AUTH', AuthParameters={"USERNAME": username,
        "PASSWORD": password}, ClientId = clientId)

# store credentials
accessToken = response['AuthenticationResult']['AccessToken']
idToken = response['AuthenticationResult']['IdToken']
print("ID token: ", idToken)




print("----------------------------------------------------------------------------")

r1 = requests.post(f"{BASE_URL}", headers={"Authorization": idToken}) # the test call
print("API Response: ", r1.status_code, r1.reason)
print("API content: ", r1.content)

#head = {'Authorization': 'token {}'.format(idToken)}
#response = requests.get(f"{BASE_URL}", headers=head)
#print(response.reason)
