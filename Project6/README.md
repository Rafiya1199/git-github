# Public api

## Background/main components

The terraform code in main.tf creates a public api on API Gateway which invokes a simple lambda function
The main.tf code provides the base URL for the API and lambda function name as outputs.

code-js.zip  is the source code for lambda function.

The cognito.tf code creates a user pool with username, password, email and name attributes.
It also creates a cognito user pool client which generates authentication tokens to authorize a user for an application.
The cognito.tf provides the user pool ID and client ID as outputs.

The terraform code in main.tf creates a public api on API Gateway which invokes a simple lambda function
The main.tf code provides the base URL for the API and lambda function name as outputs.

## create api

Run terraform init and terraform apply

## Create a cognito user

Use create_cognito_user.py to create a new cognito user

## Call the api

Use call_api.py

Update the following values call_api.py file:
clientId = 'XXXXXXXXXXXXXXXXXXXX'
username = "rafiya11"
password = "Rafiya0453!"
HOST = "https://{api_id}.execute-api.us-east-1.amazonaws.com"

## (Optional) How to test the setup?

1. Create an EC2 instance with al2 and t2.micro. Use ec2_SSM_role as instance profile and connect ec2 with SSM.
2. Save and run the python script api.py after changing the values. (or use curl command)
3. You will receive the api response and api content as output.
