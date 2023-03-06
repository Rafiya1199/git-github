# TCF44 - Create and deploy python container image for lambda

## How does it work?
We can deploy our Lambda function code as a container image. AWS provides the AWS base images for Lambda to help you build a container image for your Python function. The workflow for a function defined as a container image includes these steps:

1. Build your container image using the AWS base images for Lambda.
2. Upload the image to your Amazon ECR container registry.
3. Create the Lambda function to deploy the image 

## Steps:
1. In your project directory, add a file named app.py containing your function code. Make sure you have the import statements. For example, if you want to use the requests module and make a get request to a URI, then add the following line:
- import requests
2. In your project directory, add a file named requirements.txt. List each required library as a separate line in this file. Leave the file empty if there are no dependencies. For example, if the required library is requests, then add the below line in txt file:
- requests==2.28.2
3. Use a text editor to create a Dockerfile in your project directory. Install any dependencies under the ${LAMBDA_TASK_ROOT} directory alongside the function handler to ensure that the Lambda runtime can locate them when the function is invoked.
4. To create the container image and push the image to ECR repo, run the following commands:

- Build your Docker image: docker build -t tcf44-lambda-fn-image .

- Authenticate ecr: aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account_id>.dkr.ecr.us-east-1.amazonaws.com

- Get image ID: docker images 

- Tag the image with the image ID: docker tag <image_id> <account_id>.dkr.ecr.us-east-1.amazonaws.com/<ecr_repo>:latest

- Push the image to ecr repo: docker push <account_id>.dkr.ecr.us-east-1.amazonaws.com/<ecr_repo>:latest

5. Copy the image uri from the console and update the variable value in line # 8 in variables.tf file. Use the variable with image uri to create the lambda function. Run "terraform apply" after making sure the image uri and lambda role arn values.

## How to test the setup?
1. After deploying lambda function, open the Functions page of the Lambda console.
2. Choose the name of the function that you want to test. Choose the Test tab.
3. Under Test event, choose Saved event, and then choose the saved event that you want to use. Choose Test.
4. To review the test results, under Execution result, expand Details.

## Verification:
If you see the test result similar to the one below, then your lambda function is working:
- Execution result: succeeded