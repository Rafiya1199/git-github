# Create an archive from a file or directory of files
#In terraform ${path.module} is the current directory
data "archive_file" "sample"{
    type        = "zip"
    source_dir  = "${path.module}/python/"
    output_path = "${path.module}/python/hello-world.zip"
}

# Create a Lambda function
resource "aws_lambda_function" "sample" {
    filename       = "${path.module}/python/hello-lambda.zip"
    function_name  = var.lambda_function_name
    role           = var.lambda_role_arn
    handler        = "hello-world.lambda_handler"
    runtime        = "python3.9"
    timeout = 30
    publish = true
}
#Creates a Lambda function alias. Creates an alias that points to the specified Lambda function version.
resource "aws_lambda_alias" "test_lambda_alias" {
  name             = var.lambda_alias_name
  function_name    = var.lambda_function_name
  function_version = aws_lambda_function.sample.version

  # To use CodeDeploy, ignore change of function_version
  lifecycle {
    ignore_changes = [function_version, routing_config]
  }
}
