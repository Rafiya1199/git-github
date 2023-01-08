# The python script api.py creates a user, confirms user signup through a function. To call the function, update the values for username, password, email, name, user pool ID and client ID

import boto3
import requests

region = 'us-east-1'
def create_user(username: str, password: str, user_pool_id: str, app_client_id: str, email: str, name: str) -> None:
    client = boto3.client('cognito-idp', region)

    # initial sign up
    resp = client.sign_up(
        ClientId=app_client_id,
        Username=username,
        Password=password,
        UserAttributes=[
            {
                'Name': 'email',
                'Value': email
            },
            {
                'Name': 'name',
                'Value': name
            },
        ]
    )
    # then confirm signup
    resp = client.admin_confirm_sign_up(
        UserPoolId=user_pool_id,
        Username=username
    )

    print("User successfully created.")

    
#Call the function
# username: str, password: str, user_pool_id: str, app_client_id: str, email: str, name: str
create_user(
    "aaliya11", "Aaliya0583!",
    "{pool_id}", 
    "{client_id}", "{email_id}", "Aaliya")
