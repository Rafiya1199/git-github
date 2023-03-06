variable "aws_region" {
   type     = string
   default  = "us-east-1"
 }

variable "account_id" {
  description = "Account id"
  default     = "089999148961"
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

variable "bucket_name" {
    type        = string
    description = "S3 bucket name"
    default     = "tcf-46-ecs-exec-demo-output-129754"
}

# Tags
variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {
        Project     = "TCF",
        Environment = "Dev"
  }
}
