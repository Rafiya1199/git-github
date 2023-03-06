#IAM role for ECS
resource "aws_iam_role" "sample_app_task_execution_role" {
  name               = "sample-app-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

#IAM policy for ECS role
data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# AmazonECSTaskExecutionRolePolicy is an AWS-managed policy
data "aws_iam_policy" "ecs_task_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Attach the above policy to the execution role.
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.sample_app_task_execution_role.name
  policy_arn = data.aws_iam_policy.ecs_task_execution_role.arn
}

# Create a CloudWatch Log Group to put our logs.
resource "aws_cloudwatch_log_group" "sample_app" {
  name = "/ecs/sample-app"
}

resource "aws_cloudwatch_log_stream" "myapp_log_stream" {
  name           = "my-log-stream"
  log_group_name = aws_cloudwatch_log_group.sample_app.name
}

data "template_file" "sample-app" {
  template = file("./templates/sample-app.json.tpl")

  vars = {
    app_image      = var.app_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}

# Task definition to be used in aws_ecs_service, defines the task that will be running to provide
# our service. The idea here is that if the service decides it needs more capacity,
# this task definition provides a perfect blueprint for building an identical container.
resource "aws_ecs_task_definition" "sample_app" {
  family = "sample-app"
  execution_role_arn = aws_iam_role.sample_app_task_execution_role.arn
   # This is required for Fargate containers
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  # These are the minimum values for Fargate containers.
  cpu = var.fargate_cpu
  memory = var.fargate_memory
  container_definitions  = data.template_file.sample-app.rendered
}

#Create an ECS Cluster
resource "aws_ecs_cluster" "app" {
  name = "app"
}

resource "aws_vpc" "aws-vpc" { 
  cidr_block = "10.0.0.0/16" 
  enable_dns_hostnames = true
}

#Create an ECS service
resource "aws_ecs_service" "sample_app" {
  name            = "sample-app-service"
  task_definition = aws_ecs_task_definition.sample_app.arn
  cluster         = aws_ecs_cluster.app.id
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "sample-app"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs_task_execution_role]
}
