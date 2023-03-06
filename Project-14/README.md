## User Authentication and Authorization with AWS Cognito


## Main steps of this process are:
1- User Registration: User enters email, username and password and registers with the User Pool.
2- User Verification: AWS Cognito User Pool will send verification code by email or sms and the user enters the code to get verified with the User Pool.
3- User Login: User enters username and password and logs in with Cognito User Pool in which case a token will be provided by Cognito upon successful login.
4- Get Temporary Credentials: Cognito Identity Pool will provide temporary credentials to access AWS resource: S3 bucket using the token that was recieved on successful login.
5- User Authorization: Cognito will authorize the user with necessary permissions with IAM role.
6- AWS Resource Management: Authorized user will now have the ability to manage AWS resources such as s3 bucket according to the permissions given by AWS IAM.

## How to test the setup?
1) Configure a User pool and configure an Identity Pool
2) Allow AWS Resource Access to Identity Pool Role
3) Creating an S3 Bucket for Web Hosting.
4) Register, verify and login a user using AWS Cognito Javascript SDK.
5) Use AWS Cognito Identity JavaScript SDK to get temporary access credentials.
6) Use AWS S3 JavaScript SDK to query S3 bucket items using temporary access credentials.

## Key points in the code are:

Line 168: Get the ID token after a user is successfully logged in with AWS Cognito authentication provider.

Line 335: Get the ID token from an already logged in user session. This method is called on the page load.

Line 272: Get the temporary credentials for AWS service: S3 using ID token, Identity Pool ID and User Pool ID and updates the AWS credentials.

## Open “index.html” and replace following values in Line 48 and save.

userPoolId, clientId, region, identityPoolId
