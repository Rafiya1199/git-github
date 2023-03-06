# TCF36 - ECS with Fargate service and autoscaling config
	 
## Steps
## Prerequisites: Create VPC (or use existing vpc) and two public subnets
 1. Create a security group for the ALB and ECS. Traffic to the ECS cluster should only come from the ALB
 2. Create a target group of target_type = "ip"
 3. Configure Application Load Balancer
 - a. Select the VPC,& the 2 Subnets. 
 - b. Select the target group for your load balancer.
 4. Create a Task definition to be used in ecs service. It defines the task that will be running to provide our service.
 5. Create the ecs cluster.
 6. Create the ecs service and select the task definition, security group, subnets, load balancer created above. Select the launch_type   as "FARGATE". Set the desired_count. If the desired count is 1, it deploys a single task.
 7. Configure Autoscaling for the service. 
 - a. Set Autoscaling target. Specify the Minimum tasks as 1 and Maximum tasks as 2. 
 - b. Set the Auto Scaling policy.  Select policy_type as "TargetTrackingScaling" policy and predefined_metric_type as "ECSServiceAverageCPUUtilization". And for Target value, use 10%. 

  ## Note:
 Scaling policy's baseline has been set to 10% CPU utilization for the ECS service.
 - Once the average CPU consumption jumps above 80% as defined, the desired count gets scaled out to the value 2. If the value falls below this limit the autoscaling reduces the desired count value to 1.

 ## How to test the setup?
 Run "terraform apply" to deploy the resources. Copy the "alb_hostname" value from the output.

1. Check the load balancer: Open a new tab in your web browser and paste the DNS name of the load balancer. You should see the web page which says "Welcome to nginx!". If you see this page, the nginx web server is successfully installed and working.

2. Check the "Details" tab to verify load balancer and network config. Also check the "Auto Scaling" tab for the Minimum, maximum tasks, policy and target value.

3. Test if Auto Scaling works:


