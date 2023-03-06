variable "az_count" {
  description = "Number of AZs to cover in a given region"
  # To create an ALB at least two subnets in two different Availability Zones must be specified
  default     = "2"
}

variable "app_image" {
  description = "Image to run in the ECS cluster"
  default     = "XXXXXXXXXXXX.dkr.ecr.us-east-1.amazonaws.com/base-images:ecs-nginx-image"
}

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-east-1"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "512"
}

variable "health_check_path" {
  default = "/"
}
