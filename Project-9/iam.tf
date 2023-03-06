# IAM role for lambda
resource "aws_iam_role" "tcf36_lambda_role" {
  name = "tcf36_lambda_role"
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
  role       = "${aws_iam_role.tcf36_lambda_role.name}"
  policy_arn = "${data.aws_iam_policy.lambda_execute_policy.arn}"
}

#Create a data resource for lambda managed policy
data "aws_iam_policy" "lambda_access_policy" {
  arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}

# Attach the above IAM policy to your role
resource "aws_iam_role_policy_attachment" "lambda-access-policy-attach" {
  role       = "${aws_iam_role.tcf36_lambda_role.name}"
  policy_arn = "${data.aws_iam_policy.lambda_access_policy.arn}"
}

#Grant lambda permissions to invoke the SES service.
resource "aws_iam_role_policy" "ses_policy" {
  name = "ses_policy"
  role = aws_iam_role.tcf36_lambda_role.name

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

#IAM role to be associated with the user group1 (movies).
resource "aws_iam_role" "group1_role" {
  name = var.group1_role_name

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "cognito-identity.amazonaws.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.main.id}"
                },
                "ForAnyValue:StringLike": {
                    "cognito-identity.amazonaws.com:amr": "authenticated"
                }
            }
        }
    ]
}
EOF
}

##IAM policy to be associated with the user group1 (movies).
resource "aws_iam_role_policy" "policy1" {
  name        = "movies_policy"
  role = aws_iam_role.group1_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "execute-api:Invoke"
            ],
            "Resource": [
                "arn:aws:execute-api:${var.aws_region}:${var.account_ID}:${aws_api_gateway_rest_api.restful_api.id}/*/POST/movies"
            ]
        }
    ]
}
EOF
}

#IAM role to be associated with the user group2 (shows).
resource "aws_iam_role" "group2_role" {
  name = var.group2_role_name

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "cognito-identity.amazonaws.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.main.id}"
                },
                "ForAnyValue:StringLike": {
                    "cognito-identity.amazonaws.com:amr": "authenticated"
                }
            }
        }
    ]
}
EOF
}

##IAM policy to be associated with the user group2 (shows).
resource "aws_iam_role_policy" "policy2" {
  name        = "shows_policy"
  role = aws_iam_role.group2_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "execute-api:Invoke"
            ],
            "Resource": [
                "arn:aws:execute-api:${var.aws_region}:${var.account_ID}:${aws_api_gateway_rest_api.restful_api.id}/*/POST/shows"
            ]
        }
    ]
}
EOF
}

# IAM role to be associated with Identity pool for authenticated users
resource "aws_iam_role" "authenticated" {
  name = "cognito_authenticated"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.main.id}"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "authenticated"
        }
      }
    }
  ]
}
EOF
}

# IAM policy to be associated with Identity pool for authenticated users
resource "aws_iam_role_policy" "authenticated" {
  name = "authenticated_policy"
  role = aws_iam_role.authenticated.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "mobileanalytics:PutEvents",
        "cognito-sync:*",
        "cognito-identity:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}