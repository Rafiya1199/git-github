## admin_user_pwd.py - Python script for ADMIN_USER_PASSWORD_AUTH Authentication flow
When the AdminInitiateAuth API operation is called, it returns the required authentication parameters.
After the server-side app has the authentication parameters, it calls the AdminRespondToAuthChallenge API operation. It succeeds when you provide AWS credentials. The access token  and ID token are returned in the response.
AuthParameters: USERNAME (required), SECRET_HASH (if app client is configured with client secret), PASSWORD (required)

## srp_auth_2.py - Python script for USER_SRP_AUTH Authentication flow
When the InitiateAuth API operation, the AuthParameters are used: USERNAME (required), SRP_A (required), SECRET_HASH (required if the app client is configured with a client secret). The operation returns the required authentication parameters.  If the InitiateAuth call is successful, the response has included PASSWORD_VERIFIER as the ChallengeName and SRP_B, SALT, Secret_Block, user SRP ID in the challenge parameters. 

And then the RespondToAuthChallenge API operation is called with the PASSWORD_VERIFIER ChallengeName and the necessary parameters in ChallengeResponses: PASSWORD_CLAIM_SIGNATURE , PASSWORD_CLAIM_SECRET_BLOCK , TIMESTAMP , USERNAME. If the call to RespondToAuthChallenge is successful and the user signs in, Amazon Cognito issues access and id tokens.

## user_srp_auth.py - Python script for USER_SRP_AUTH Authentication flow (uses warrant module)
In this python script, we use the Python library "Warrant" for using AWS Cognito. With support for SRP.
Here, we call the authenticate_user() method which in turn calls the InitiateAuth and  RespondToAuthChallenge API operations to get the id and access token.