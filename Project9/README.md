# Build Contact Us Form Functionality using terraform and OpenAPI 3.0

## How does it work?
Receive Emails from Your Site's "Contact Us" form Using AWS SES, Lambda, & API Gateway

The user will fill a form by simply typing their name, email-id, message and then click submit. This should send an email to the site's owner without ever leaving the website.

## Steps to build the functionality:
1. Set up AWS SES email identity.
2. Create a Lambda function that is going to receive the form data and call SES. 
3. Define your REST API by using an OpenAPI 3.0 definition file. 
4. Use the file to create a REST API with lambda integration.
5. (Optional) Set up a custom domain for the API

## Note:
1. When we use custom domain, we cannot use API stage names in the OpenAPI 3.0 definition file. In OpenAPI 3.0, you use the servers array to specify one or more base URLs for your API. For Example: 
servers:
  url: "https://contactusrestapi.dev.thecloudforce.net"

2. When we use the API endpoint URL instead of the custom domain, the API stage (ex:dev) can be used in the OpenAPI 3.0 definition file:
servers:
  url: "https://zraefsbe9e.execute-api.us-east-1.amazonaws.com/{basePath}"
  variables:
    basePath:
      default: "/dev"

## How to test the setup?
## Prerequisites
- Step 1: Add your email id in the the variable "email_id" (in variables.tf file line # 8). Verify your email address by clicking on the link sent to the email id.
- Step 2: Modify lambda function source code: "index.js" file under the folder "code", by adding your email id (in line # 13 & 25). The ID should be same as the one in Step 1.
- Step 3: Change the variables (in variables.tf file) certificate arn, zone id and domain name if required. And run terraform apply command


1. To test the functionality, use the code editor: https://jsfiddle.net/ where we need to add the HTML and JavaScript code.
2. Copy HTML code in "form.html" file and JavaScript code in "submit_fn.js" file. Paste the code in the JSFiddle editor. Update line # 10 in the "submit_fn.js" file to use the API endpoint url or custom domain url (URL is displayed in the output).
3. Run the code by clicking on "Run" icon at the top left corner.
4. As a result, you will see the "Contact Us" window, fill in the details: name, email-id, message and click "submit". Then, the window will display a message: "Email sent successfully!".
5. Check your email, you should receive a mail which has the following format:
   "You just got a message from Alisha"
       Email ID:     rafiyafathima.11@gmail.com
	     Phone Number: 8966695310
       Message:      Project Details"