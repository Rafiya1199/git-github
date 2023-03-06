# TCF32 - Create a public api using tf along with the access control based on custom scopes

## AWS Services used:
Cognito User Pools, API gateway, and Lambda

## How does it work?
If you have different app clients that need varying levels of access to your API resources, you can provide differentiated access based on the custom scopes that you define. This could be done by: 
- defining a resource server with custom scopes in your Amazon Cognito user pool. 
- creating and configuring an Amazon Cognito authorizer for your API Gateway API to authenticate requests to your API resources.

## Steps
- Step 1: Create a Amazon Cognito user pool with a user, an app client, and a domain name
- Step 2: Create an API Gateway REST API with two resources
- Step 3: Add a resource server with custom scopes in your user pool
- Step 4: Create an Cognito user pool authorizer and integrate it with your API
- Step 5: Get a user pool access token for testing
- Step 6: Call your API as a test

## (Optional) How to test the setup?
Note: the API method call succeeds if any custom scope that's specified on the method matches a custom scope that's claimed in the incoming token. Otherwise, the call fails with a 401 Unauthorized response.

- 1. Run the python script "callApi_scopes.py" after updating values in line number 5-15 according to your terraform output values. 
- 2. When we get the access token from python script, it includes the custom scope. Hence the API returns a response successfully.

## Note
- When the Cognito user pool client is configured to generate a client secret with USER_PASSWORD_AUTH flow and "client credentials" grant type with custom scopes, the "callApi_scopes.py" python script provides the access token from cognito domain endpoint with custom scope claim. As aresult, API returns a successful response.
- If the Cognito user pool client is configured to use "implicit" grant type, USER_PASSWORD_AUTH or USER_SRP_AUTH with custom scopes, the "example.py" python script provides the access token without custom scope claim. As aresult, we get 401 Unauthorized error.