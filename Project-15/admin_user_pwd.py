import boto3


region = 'us-east-1'
cognito = boto3.client('cognito-idp', region)

clientId = '1gga45qf3o4h4enqq4g322jbvg'
userPoolId = 'us-east-1_Dxr1V0dC5'
username = "rafiya"
password = "Rafiya123!"

response = cognito.admin_initiate_auth(
    UserPoolId = userPoolId,
    ClientId = clientId,
    AuthFlow = 'ADMIN_USER_PASSWORD_AUTH', 
    AuthParameters={"USERNAME": username, "PASSWORD": password})

# store credentials
accessToken = response['AuthenticationResult']['AccessToken']
idToken = response['AuthenticationResult']['IdToken']
print("ID token: ", idToken)
print("--------------------------------------------------------------------------------------------------")
print("--------------------------------------------------------------------------------------------------")
print("Access token: ", accessToken)