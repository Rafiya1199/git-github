from warrant.aws_srp import AWSSRP


USERNAME="rafiya"
PASSWORD="Rafiya123!"
POOL_ID='us-east-1_Dxr1V0dC5'
CLIENT_ID = "66houh72qh375t5s336cslnfmi"

aws = AWSSRP(username=USERNAME, password=PASSWORD, pool_id=POOL_ID,
             client_id=CLIENT_ID)
tokens = aws.authenticate_user()
id_token = tokens['AuthenticationResult']['IdToken']
refresh_token = tokens['AuthenticationResult']['RefreshToken']
access_token = tokens['AuthenticationResult']['AccessToken']
token_type = tokens['AuthenticationResult']['TokenType']
print("ID token: ", id_token)
print("--------------------------------------------------------------------------------------------------")
print("--------------------------------------------------------------------------------------------------")
print("Access token: ", access_token)