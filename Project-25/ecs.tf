#IAM role for ECS
resource "aws_iam_role" "ecs-exec-demo-task-execution-role" {
  name               = "ecs-exec-demo-task-execution-role"
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
  role       = aws_iam_role.ecs-exec-demo-task-execution-role.name
  policy_arn = data.aws_iam_policy.ecs_task_execution_role.arn
}

##For the ECS task role, we need to craft a policy that allows the container to open the secure channel session via SSM 
## and log the ECS Exec output to both CloudWatch and S3 
resource "aws_iam_role" "ecs-exec-demo-task-role" {
  name               = "ecs-exec-demo-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

resource "aws_iam_role_policy" "ecs-exec-demo-task-role-policy" {
  name = "ecs-exec-demo-task-role-policy"
  role = aws_iam_role.ecs-exec-demo-task-role.id
  policy = jsonencode({
"Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        }
      ]
  })
}

resource "aws_iam_role_policy" "executeCommand-policy" {
  name = "ecs-executeCommand-policy"
  role = aws_iam_role.ecs-exec-demo-task-role.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ecs:ExecuteCommand",
            "Resource": "*"
        }
    ]
  })
}

## IAM role with a policy to handle the autoscaling via the service application-autoscaling.amazonaws.com. 
##This means you permit the autoscaling service to adjust the desired count of your ECS Service based on Cloudwatch metrics.
## define a role that can be assumed by the application autoscaling service and get the policy AmazonEC2ContainerServiceAutoscaleRole attached. 
resource "aws_iam_role" "ecs-autoscale-role" {
  name = "tcf46-ecs-scale-application"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "application-autoscaling.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-autoscale" {
  role = aws_iam_role.ecs-autoscale-role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}

data "template_file" "sample-app" {
  template = file("./templates/sample-app.json.tpl")

  vars = {
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
    account_id     = var.account_id
  }
}

# Task definition to be used in aws_ecs_service, defines the task that will be running to provide
# our service. The idea here is that if the service decides it needs more capacity,
# this task definition provides a perfect blueprint for building an identical container.
resource "aws_ecs_task_definition" "sample_app" {
  family = "ecs-exec-demo"
  execution_role_arn = aws_iam_role.ecs-exec-demo-task-execution-role.arn
  task_role_arn = aws_iam_role.ecs-exec-demo-task-role.arn
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = var.fargate_cpu
  memory = var.fargate_memory
  container_definitions = data.template_file.sample-app.rendered
}

#Create an ECS Cluster
resource "aws_ecs_cluster" "app" {
  name = "demoapp"
}

#Create an ECS service
resource "aws_ecs_service" "sample_app" {
  name            = "sample-app-service"
  task_definition = aws_ecs_task_definition.sample_app.arn
  cluster         = aws_ecs_cluster.app.id
  desired_count   = var.app_count
  launch_type     = "FARGATE"
  platform_version = "1.4.0"
  enable_execute_command = true

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = [var.public_subnet1_id, var.public_subnet2_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb-example.id
    container_name   = "nginx"
    container_port   = var.app_port
  }

  depends_on = [aws_lb_listener.front_end, aws_iam_role_policy_attachment.ecs_task_execution_role]
}

## ECS service autoscaling
##The target has a minimum desired count of 1 and a maximum desired count of 2 to which the application autoscaling service can scale-out.
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.app.name}/${aws_ecs_service.sample_app.name}"
  ##Scalable dimension of the scalable target.
  scalable_dimension = "ecs:service:DesiredCount"
  ##AWS service namespace of the scalable target.
  service_namespace  = "ecs"
  role_arn           = aws_iam_role.ecs-autoscale-role.arn
}

##Application AutoScaling Policy resource.
resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "appScalingPolicy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

   target_tracking_scaling_policy_configuration {
     predefined_metric_specification {
       predefined_metric_type = "ECSServiceAverageCPUUtilization"
     }
 
     target_value = 10
   }
   depends_on = [aws_appautoscaling_target.ecs_target]
}

# resource "null_resource" "update-service" {
#   provisioner "local-exec" {
#     command = "aws ecs update-service --cluster demoapp --service sample-app-service --task-definition ecs-exec-demo --force-new-deployment --enable-execute-command"
#   }
# }
