# TCF33 - Set up Google as a federated identity provider in an Amazon Cognito user pool

## How does it work?
Amazon Cognito user pools allow sign-in through a third party (federation), including through a social IdP such as Google. With the built-in hosted web UI, Amazon Cognito provides token handling and management for all authenticated users. You must enable the hosted UI to integrate with supported social identity providers. When Amazon Cognito builds your hosted UI, it creates OAuth 2.0 endpoints that Amazon Cognito and your OIDC and social IdPs use to exchange information.

## Steps
## Prerequisites
- 1. Create a Google API Console project
- 2. Configure the OAuth consent screen: for Authorized domains, enter amazoncognito.com.
- 3. Get OAuth 2.0 client credentials: Client ID and Client secret.
- 4. Update the variable values: OAuth_client_id and OAuth_client_secret in variables.tf file (line number 45 & 52) after getting the OAuth 2.0 client credentials. Make sure that the cognito domain_prefix and region values in variables.tf file (line number 38) are similar to the one used in Step 3 - Get OAuth 2.0 client credentials. 
- 5. Run "terraform apply" command to create an Amazon Cognito user pool with Google as a federated IdP, an app client with required settings and cognito domain.

The set up procedure is documented in the following file:
https://docs.google.com/document/d/1B62ThrbOeUj0cqVQxRYoQLEk1xxP0--9PcILLfXB2Fo/edit?usp=share_link

## How to test the setup?
- 1. Get the login endpoint URL, which is provided as a terraform output value. 
- 2. Enter the login endpoint URL in your web browser.
- 3. On your login endpoint webpage, choose "Continue with Google" or select "Sign in with Google", choose your Google account and sign in.

After successfully authenticating, you're redirected to your Amazon Cognito app client's callback URL. The user pool-issued JSON web tokens (JWT) appear in the URL in your web browser's address bar. 

Note: An auto generated user pool group is created for users who sign in using Google.