Create a Lambda function that gets triggered on a tag update.

## How does it work?
Tag change → CloudWatch event → Lambda triggered due to event.

When a change is detected in EC2 instance tags, the CloudWatch event rule triggers the target lambda funtion.

Note: Before running "terraform plan" command, comment line number 31 in "main.tf" file which starts with "source_code_hash". And then run "terraform apply".

## Background/main components

 Lambda function, EC2 instance (used to switch tags on the instance to test your trigger), Cloud Watch event rule, cloud watch event target. 

## (Optional) How to test the setup?
1. Change the EC2 instance tags through variable "tags" in variables.tf file. For example, change the value for key named "Group" from   "production" to ""test: 

variable "tags" {
  type        = map(string)
  default     = {
        webserver = "test",
        Group = "production"
  }
}
2. Verify if the lambda function got triggered on a tag update: in the Lambda console, click on the monitor tab > CloudWatch Logs, to see the "Recent invocations" with timestamp.
   
