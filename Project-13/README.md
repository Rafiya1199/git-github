# TCF30 - Using Cognito groups to control access to API endpoints

## AWS Services used:
Cognito User Pools, Cognito identity pools, API gateway, and Lambda

## How does it work?
User groups in Cognito provide a simple way to control access to different API endpoints. Create a Cognito identity pool, and configure the Cognito user pool as an authentication provider.

By default, Cognito identity pools have just an Authenticated and Unauthenticated role - but when setting up the user pool as the Cognito identity pool's authentication provider, you can specify "Choose role from token" under "Authenticated role selection". This will override the default authenticated role for the identity pool, and instead use the IAM role associated with the user's Cognito user pool group. You can attach a policy to the Cognito user pool group role to control access to particular API endpoint.

## Steps to build the functionality:
## Prerequisites
1. Change the variable values: aws region and the account ID in variables.tf file.
2. Comment out line number : 95 & 106 and run "terraform plan" to create the zip files for lambda functions. Then uncomment the lines.

Run "terraform apply" command to deploy the resources. 
1. userPool.tf - Creates a Cognito user pool with a App Client, two users, cognito domain, two groups with a single user. 
2. identityPool.tf - Creates a Cognito identity pool and configures it to use "Choose role from token" option under Authenticated role selection. Also used to attach an IAM role for authenticated users
3. main.tf - Creates a REST API with two resources each with HTTP GET method which has "AWS IAM" authorization. Each HTTP methods has Lambda integration. It also creates a Stage and exposes the API at a URL.
4. iam.tf - Creates the IAM roles and policies for Cognito user pool groups, API gateway, Lambda functions, and authenticated users.
5. outputs.tf - Provides the App client id, lambda function names, Cognito user pool id, user names, group names, Cognito identity pool id, and invoke url of the API.
6. variables.tf - Can be used to change the aws region and the account ID.

## (Optional) How to test the setup?
To test the setup run the python script "callApi_groups.py"
## Prerequisites
Update the script variable values in line number 6-18 according to your terraform output values.
## Verification:
1. User in the movies-group can access the /movies endpoint while /shows endpoint will deny their request.
2. User in the shows-group will get a successful response from the /shows endpoint but /movies endpoint will deny their request.  
