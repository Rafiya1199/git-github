Create a code deploy application using Terraform to deploy a lambda function using Blue/Green strategy.

# How to deploy and test tf code

- When lambda is deployed for the first time, the variables lambda_version & lambda_alias_version is equal to 1.
-After the initial execution, the variables lambda_version & lambda_alias_version are updated (lambda_version > lambda_alias_version) and
-function_code var is also updated when lambda function version needs to be updated
- The lambda_version, lambda_alias_version and function_code variables need to be updated for testing.
-if the lambda is already created, then lambda_version = 2, lambda_alias_version = 1, function_code = hello-world.zip
-for the second test, lambda_version = 3, lambda_alias_version = 2, function_code = sample_code.zip
-The lambda is deployed through tf for the first time. The next time a new lambda version is created by the tf run. However, alias is updated through codedeploy.
-Additionally, you're creating a deployment through the tf code itself.
