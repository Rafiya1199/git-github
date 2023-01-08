# IAM role for lambda
resource "aws_iam_role" "tcf25_lambda_role" {
  name = "tcf25_lambda_role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

#Create a data resource for lambda managed policy
data "aws_iam_policy" "lambda_execute_policy" {
  arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

# Attach the above IAM policy to your role
resource "aws_iam_role_policy_attachment" "lambda-execute-policy-attach" {
  role       = "${aws_iam_role.tcf25_lambda_role.name}"
  policy_arn = "${data.aws_iam_policy.lambda_execute_policy.arn}"
}

#Create a data resource for lambda managed policy
data "aws_iam_policy" "lambda_access_policy" {
  arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}

# Attach the above IAM policy to your role
resource "aws_iam_role_policy_attachment" "lambda-access-policy-attach" {
  role       = "${aws_iam_role.tcf25_lambda_role.name}"
  policy_arn = "${data.aws_iam_policy.lambda_access_policy.arn}"
}

#Grant lambda permissions to invoke the SES service.
resource "aws_iam_role_policy" "ses_policy" {
  name = "ses_policy"
  role = aws_iam_role.tcf25_lambda_role.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ses:SendEmail",
                "ses:SendRawEmail"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
