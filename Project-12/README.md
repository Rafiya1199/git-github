## Use temporary AWS credentials to access S3 bucket using cognito user pools and federated identities.

## Steps:
1. Create an IAM role which will define the permissions and the access to aws resources for an authentic and unauthentic user. 
2. Create a cognito user pool, app client (SRP auth) and federated identity pool.
3. Configure the identity pool by selecting "cognito Authentication providers" and enter your UserpoolId and App client id. Click on Edit identity pool and select the roles made from the drop down for authenticated_role and for unauthenticated_role carefully.
4. Create a private S3 bucket.
5. Run this script to get ID_token, identity_id (Id of the user in the Identity pool) for a cognito username and the temporary aws credentials: Access key, Secret key and Session token for a registered user.
6. Using the same script upload a file on S3 bucket using these temporary credentials.
7. Make sure that the IAM role in step 1 should allow users to access only a folder inside the s3 bucket. Their CRUD operations are limited only to their folder which is identified by their identity_id. This role grants Get/Put/Delete permission to a user in a folder in the S3 bucket.


## How to test the setup?
Run the script "cog_auth_s3.py" after updating the values in line number 5-13.
The ID token, Identity Id, Access key, Secret key and Session token are printed on the screen. And the following functions are called:

1. authenticate_user() - returns the ID_token using the Python library "Warrant". Required paraemeters: username, password, user pool id and client id.
2. get_id() - returns the Identity_id. Required paraemeters: Identity pool id, identity provider, id_token
3. get_credentials_for_identity() - returns AWS temporary credentials. Required paraemeters: Identity_id, identity provider, id_token
4. put_file() - uploads a file to s3 bucket in a foldername (identified by user’s identity_id). Required paraemeters: access_key, secret_key, region, session_token, identity_id, BUCKET_NAME, upload_filename_path

With the temporary user credentials a user can access a folder with the name for example: “us-east-1:1412a01a-567b-4bfd-956f-2acfa1efd61f” in the S3 bucket. Using the "put_file" function, a user can upload any file in foldername (identified by user’s identity_id) in the private s3 bucket. For testing purpose, remove your credentials file.

Optional: Try changing the identity_id in the "put_file" function call. This will show an authentication error because a user is only allowed to upload file to his/her foldername.

