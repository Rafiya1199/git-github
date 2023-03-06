# Create a cognito user pool
resource "aws_cognito_user_pool" "user_pool" {
  name = var.user_pool_name

  password_policy {
    minimum_length    = 6
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  username_configuration {
    case_sensitive = false
  }
}


# Create a cognito user pool client which generates authentication tokens to authorize a user for an application.
resource "aws_cognito_user_pool_client" "user_pool_client" {
  name                         = var.app_client_name
  explicit_auth_flows          = ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]

  user_pool_id = aws_cognito_user_pool.user_pool.id
}

##Create 2 users in the user pool
resource "aws_cognito_user" "user1" {
  user_pool_id = aws_cognito_user_pool.user_pool.id
  username     = var.user1_name
  password     = var.user1_password
}

resource "aws_cognito_user" "user2" {
  user_pool_id = aws_cognito_user_pool.user_pool.id
  username     = var.user2_name
  password     = var.user2_password
}

## Create a Cognito User Pool Domain resource.
resource "aws_cognito_user_pool_domain" "main" {
  domain       = var.domain_name
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

## Create a group and associated an IAM role
resource "aws_cognito_user_group" "group1" {
  user_pool_id = aws_cognito_user_pool.user_pool.id
  name         = var.group1_name
  role_arn     = aws_iam_role.group1_role.arn
}

## Create a second group and associated an IAM role
resource "aws_cognito_user_group" "group2" {
  user_pool_id = aws_cognito_user_pool.user_pool.id
  name         = var.group2_name
  role_arn     = aws_iam_role.group2_role.arn
}

##Add user1 to group1.
resource "aws_cognito_user_in_group" "example" {
  user_pool_id = aws_cognito_user_pool.user_pool.id
  group_name   = aws_cognito_user_group.group1.name
  username     = aws_cognito_user.user1.username
}

##Add user2 to group2.
resource "aws_cognito_user_in_group" "example2" {
  user_pool_id = aws_cognito_user_pool.user_pool.id
  group_name   = aws_cognito_user_group.group2.name
  username     = aws_cognito_user.user2.username
}
