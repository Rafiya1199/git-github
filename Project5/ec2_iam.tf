#Create an IAM instance profile.
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
}

# IAM role for ec2
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

#IAM policy for ec2 role
resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2_policy"
  role = aws_iam_role.ec2_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "1",
            "Effect": "Allow",
            "Action": [
                "ec2messages:AcknowledgeMessage",
                "ec2messages:DeleteMessage",
                "ec2messages:FailMessage",
                "ec2messages:GetEndpoint",
                "ec2messages:GetMessages",
                "ec2messages:SendReply",
                "ec2:DescribeInstances",
                "ssm:DescribeAssociation",
                "ssm:GetDeployablePatchSnapshotForInstance",
                "ssm:GetDocument",
                "ssm:DescribeDocument",
                "ssm:GetManifest",
                "ssm:GetParameter",
                "ssm:GetParameters",
                "ssm:ListAssociations",
                "ssm:ListInstanceAssociations",
                "ssm:PutInventory",
                "ssm:PutComplianceItems",
                "ssm:PutConfigurePackageResult",
                "ssm:UpdateAssociationStatus",
                "ssm:UpdateInstanceAssociationStatus",
                "ssm:UpdateInstanceInformation",
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel",
                "ssm:DescribeInstanceInformation",
                "ssm:GetConnectionStatus",
                "ssm:StartSession",
                "ssm:ListAssociations",
                "ssm:DescribeSessions",
                "ssm:DescribeInstanceProperties",
                "ssm:CreateDocument",
                "ssm:GetDocument",
                "ssm:UpdateDocument",
                "ssm:DeleteDocument",
                "cognito-idp:CreateUserPoolClient",
                "cognito-idp:DeleteUserPoolClient",
                "cognito-idp:AdminConfirmSignUp",
                "cognito-idp:AdminInitiateAuth",
                "cognito-idp:AdminDeleteUser",
                "cognito-idp:AdminCreateUser",
                "cognito-idp:AdminSetUserPassword",
                "execute-api:Invoke",
                "execute-api:ManageConnections"
            ],
            "Resource": "*"
        }
    ]
}

EOF
}

#Create a data resource for the ssm managed policy
data "aws_iam_policy" "ec2_ssm_access" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach the above IAM policy to your role
resource "aws_iam_role_policy_attachment" "ec2role-policy-attach" {
  role       = "${aws_iam_role.ec2_role.name}"
  policy_arn = "${data.aws_iam_policy.ec2_ssm_access.arn}"
}
