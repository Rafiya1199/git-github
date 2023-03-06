variable "aws_region" {
   type     = string
   default  = "us-east-1"
 }

variable "app_image" {
  description = "Image to run in the ECS cluster"
  default     = "089999148961.dkr.ecr.us-east-1.amazonaws.com/base-images:ecs-nginx-image"
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

variable "default_vpc_id" {
     type     = string
     default  = "vpc-023bddfc27702b2e9"
}

variable "public_subnet1_id" {
     type     = string
     default  = "subnet-0215ce3d092efed36"
}

variable "public_subnet2_id" {
     type     = string
     default  = "subnet-065ecfe7b2f7c65c7"
}
