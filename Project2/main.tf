terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#IAM role for codepipeline
resource "aws_iam_role" "codepipeline_role" {
  name = "pipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# IAM role for codebuild
resource "aws_iam_role" "codeBuild_role" {
  name = "codeBuild_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
# IAM role for cloudWatch 
resource "aws_iam_role" "CloudWatch_role" {
  name = "cloudWatch_role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "events.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}
#IAM policy for cloudWatch role
resource "aws_iam_role_policy" "cwEvent_policy" {
  name = "cwEvent_policy"
  role = aws_iam_role.CloudWatch_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "codepipeline:*"
            ],
            "Resource": "*"
        }
    ]
}

EOF
}
#IAM policy for codepipeline role
resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "codecommit:*",
        "codebuild:*",
        "s3:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

#IAM policy for codeBuild role
resource "aws_iam_role_policy" "codeBuild_role" {
  role = aws_iam_role.codeBuild_role.name

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "codecommit:*",
            "logs:CreateLogStream",
            "logs:CreateLogGroup",
            "logs:PutLogEvents",
            "ecr:GetDownloadUrlForLayer",
            "s3:*",
            "ecr:*"
          ],
          "Resource": "*"
        }
    ]
}
POLICY
}


#Create a CodeCommit repo
resource "aws_codecommit_repository" "repo" {
  repository_name = "test_docker"
  description     = "CodeCommit repository for building docker images"

}

#Create an ECR private repo
resource "aws_ecr_repository" "tcf-repo" {
  name                 = "tcf-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

#Create a codeBuild project
resource "aws_codebuild_project" "example" {
  name          = "test-project"
  description   = "test_codebuild_project"
  build_timeout = "5"
  service_role  = aws_iam_role.codeBuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = "true"

  }

  source {
    type      = "CODECOMMIT"
    location  = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/test_docker"
    buildspec = file("${path.module}/buildspec.yml")

    git_submodules_config {
      fetch_submodules = true
    }
  }
}

#Create an S3 bucket for codepipeline
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "test-bucket0453"
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  acl    = "private"
}

#Create a codepipeline
resource "aws_codepipeline" "codepipeline" {
  name     = "tf-test-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName       = aws_codecommit_repository.repo.repository_name
        BranchName           = "main"
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.example.name
      }
    }
  }
}

#Create a CloudWatch Events rule
resource "aws_cloudwatch_event_rule" "pipeline_rule" {
  name        = "Trigger_pipeline"
  description = "Trigger Pipeline on PR merge"
  role_arn    = aws_iam_role.CloudWatch_role.arn

  event_pattern = <<EOF
  {
    "detail-type":["CodeCommit Pull Request State Change"],
    "source":["aws.codecommit"],
    "resources": ["arn:aws:codecommit:us-east-1:089999148961:test_docker"],
    "detail": {
    "event":["pullRequestMergeStatusUpdated"],
    "sourceReference":["refs/heads/${var.source_branch}"],
    "destinationReference":["refs/heads/${var.destination_branch}"],
    "repositoryNames":["test_docker"],
    "isMerged": ["True"],
    "mergeOption":["${var.merge_type}"]
    }
  }
EOF
}

#Create a cloudWAtch target to trigger pipeline
resource "aws_cloudwatch_event_target" "target_pipeline" {
  rule      = aws_cloudwatch_event_rule.pipeline_rule.name
  target_id = "TriggerCodepipeline"
  arn       = aws_codepipeline.codepipeline.arn
  role_arn  = aws_iam_role.CloudWatch_role.arn
}
