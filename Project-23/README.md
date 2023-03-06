## TCF 42 Create an S3 event notification to SQS

## Steps:
1. Create a s3 bucket

2. Create an Amazon SQS queue and to allow Amazon S3 to send messages to the queue, add the required policy to the SQS queue. The policy should allow the S3 bucket to send ObjectCreated event notifications to the specified SQS queue.

3. Create an S3 event to send a notification to the SQS queue when an object is uploaded to the bucket.

## How to test the setup?
## Prerequisites: 
- Make sure that the line# 55-65 are commented in main.tf file before running "terraform apply".
- Run "terraform apply" to deploy the resources

1. After deploying the resources, uncomment line# 55-65 in main.tf file. Save the main.tf file and again run "terraform apply" to upload 2 files: index.html and error.html in the s3 bucket. 
2. In the navigation pane, choose the queue.
- Choose Send and receive messages.
- Choose Poll for messages.
- Amazon SQS begins to poll for messages in the queue. The progress bar on the right side of the Receive messages section displays the duration of polling.
- The Messages section displays a list of the received messages for the uploaded s3 files. For each message, the list displays the message ID, Sent date, Size, and Receive count. Click on a "message" and select the "Body" tab. Check the S3 object key: index.html or error.html.
- If you received 2 messages for index.html and error.html file then your configuration is correct
