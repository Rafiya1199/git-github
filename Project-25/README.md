# TCF46 - ECS with Fargate service with exec configuration

## How it works?
Amazon ECS Exec allows you to access a container running on an Amazon EC2 instance or AWS Fargate using the AWS CLI. AWS makes use of an existing technology called AWS Systems Manager (SSM) Session Manager and IAM policies to allow developers to access running containers directly from the command-line interface. AWS ECS execute command allows you to run a command remotely from your terminal on a container within a task in AWS.

## Steps
1. Install the session manager plugin for AWS CLI
2. Add SSM permissions to the task IAM role
3. Add ECS ExecuteCommand permission to your IAM role
4. Enable ECS Exec for your ECS task and services
5. To verify if a task has ExecuteCommand enabled you can run the aws ecs describe-tasks command to check its configuration. Modify the below command with your task id and cluster name.

- aws ecs describe-tasks --cluster demoapp --region us-east-1 --tasks 4537f45ffec24de080882a6a3748ec5f
- Note: If everything went well, you’ll receive the following output with enableExecuteCommand set to true

6. Log in to the container using ECS exec. Run the aws ecs execute command with the task id and container name to log in.
- aws ecs execute-command --cluster demoapp --task da2a02d812dd4cfcb95f78e70052bd59 --container nginx --interactive --command "/bin/bash"

7. Now that you’re logged into the ECS container, you can interactively run commands to gather data or change configurations.

## Verification
Output you’ll see when you’re executing aws ecs execute-command on an actual running container:

The Session Manager plugin was installed successfully. Use the AWS CLI to start a session.
Starting session with SessionId: ecs-execute-command-05913e4a1d0e32636
/ #

8. To check auto scaling, run the following command to load the CPU:
- dd if=/dev/zero of=/dev/null
- Note: This increases the desired count of tasks from 1 to 2. Scale in and scale out actions take place when the  Average cpu utilization reaches above or below 10%. ECS events tab and Cloud watch alarms history shows a similar message for scale out action:

Message: Successfully set desired count to 2. Change successfully fulfilled by ecs. Cause: monitor alarm TargetTracking-service/demoapp/sample-app-service-AlarmHigh-22c1fbb2-aed5-484d-9cc2-131ed021b611 in state ALARM triggered policy appScalingPolicy
