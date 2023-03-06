# Build Contact Us Form Functionality using terraform 

## How does it work?
Receive Emails from Your Site's "Contact Us" form Using AWS SES, Lambda, & API Gateway

The user will fill a form by simply typing their name, email-id, message and then click submit. This should send an email to the site's owner without ever leaving the website.

## Steps to build the functionality:
1. Set up AWS SES email identity. Add your email id in the the variable "email_id" (in variables.tf file). Verify your email address by clicking on the link sent to the email id.
2. Create a Lambda function that is going to receive the form data and call SES. Test the lambda function by using the source code in "test_lambda.js" file under the folder "code". Modify "test_lambda.js", by adding your email id (in line # 7 & 17).
3. Create API Gateway, to send HTTP requests to the Lambda function we created.

## (Optional) How to test the setup?
## Prerequisites
   Modify lambda function source code: "index.js" file under the folder "code", by adding your email id (in line # 13 & 25). The ID should be same as the one in Step 1. And then update the API endpoint URL (line # 10)in the "submit_fn.js" file (URL is displayed in the output).

1. To test the functionality, use the code editor: https://jsfiddle.net/ where we need to add the HTML and JavaScript code.
2. Copy HTML code in "form.html" file and JavaScript code in "submit_fn.js" file. Paste the code in the JSFiddle editor.
3. Run the code by clicking on "Run" icon at the top left corner.
4. As a result, you will see the "Contact Us" window, fill in the details: name, email-id, message and click "submit". Then, the window will display a message: "Email sent successfully!".
5. Check your email, you should receive a mail which has the following format:
  "You just got a message from (name) - (email-id): (Message).
  Example: "You just got a message from Zara - namo@trains.com: I need job details.
