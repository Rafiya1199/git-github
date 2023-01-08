Private api with authentication

## Intro/Background

- The terraform code in main.tf creates a private api with vpc endpoint on API Gateway which invokes a simple lambda function. The file also creates ec2 instance, vpc, subnets, internet and NAT gateways using modules "vpc" and ec2_instances. The configuration in this file is used if you want to create a private api and call the api from ec2 instance (connected with ssm) in a private subnet with internet access.
- The output.tf provides the base URL for the API, lambda function name, api vpc endpoint id, the user pool ID and client ID as outputs.
- code-js.zip  is the source code for lambda function.
- The cognito.tf code creates a user pool with username, password, email and name attributes. It also creates a cognito user pool client which generates authentication tokens to authorize a user for an application.
- The network.tf code creates a vpc, subnet, security group, ec2 instance (from ec2 module), api vpc endpoint, and 3 more endpoints (for ec2 & ssm communication). This file is used only if you want to create a private api and call the api from ec2 instance (connected with ssm) in a private subnet without internet access. If you want to use this file then comment out line #12-61 in main.tf file and line # 1-9 in outputs.tf. If you don't want to use the file then comment all the lines in the file.
- ec2_iam.tf file creates an IAM instance profile and EC2 role. 

## How to test the setup?

### Create a cognito user

Run the file: create_cognito_user.py to create a user in the user pool.

### Part 1: Private API setup with ssm endpoints and EC2 in private subnet without internet access (network.tf config)
### Follow the steps to test the setup:

1. Before running terraform apply, make sure to uncomment the network.tf file and comment out line #12-61 in main.tf file and line # 1-9 in outputs.tf. 
2. Run python scripts in vs code: “create_cognito_user.py” to create a user and “call_api.py” to generate ID token.
3. Connect the EC2 instance with SSM Session Manager. Use the curl command in ec2 ssm session with token and API url to verify if the API call is successful. The API content is received as output after using the curl command with the following format:

curl -H "Authorization: $ID_TOKEN" https://{rest-api-id}-{vpce-id}.execute-api.{region}.amazonaws.com/{stage}

Example: curl -H "Authorization: $ID_TOKEN" https://y4w0yvw0rg-vpce-02d0f1c8911ee44c1.execute-api.us-east-1.amazonaws.com/DEV/{proxy+}
 

### Part 2: Private API setup with NAT gateway, Internet gateway and EC2 in private subnet (main.tf config)
### Follow the steps to test the setup:

1. Before running terraform apply, make sure to uncomment everything except network.tf file.
2. Connect the EC2 instance with SSM Session Manager.
3. Save and run the python script: call_api.py after updating following params appropriately in the script. (or use curl command)

```python
clientId = '21sn0ldh6a1le4ko8lh16e4k4e'
username = "rafiya11"
password = "Rafiya0453!"
HOST = "https://0rxyy2znzb.execute-api.us-east-1.amazonaws.com"
```

3. You will receive the api response and api content as output.
