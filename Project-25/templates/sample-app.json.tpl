[
    {   
        "family": "ecs-exec-demo",
        "executionRoleArn": "arn:aws:iam::${account_id}:role/ecs-exec-demo-task-execution-role",
        "taskRoleArn": "arn:aws:iam::${account_id}:role/ecs-exec-demo-task-role",
        "networkMode": "awsvpc",
        "name": "nginx",
        "image": "nginx",
        "linuxParameters": {
            "initProcessEnabled": true
            },
        "portMappings": [
            {
                "containerPort": ${app_port},
                "hostPort": ${app_port}
            }
        ],
        "requiresCompatibilities": [
            "FARGATE"
        ],
        "cpu": ${fargate_cpu},
        "memory": ${fargate_memory}
    }
]