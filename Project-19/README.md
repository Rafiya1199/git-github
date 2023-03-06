# TCF38 - Create an application load balancer with EC2 instances
 	 
 ## Steps
 ## Prerequisites: Create VPC (or use existing vpc) and two public subnets each with a different AZ
1. Create one security group for the EC2 instances and the second one for the ALB. Traffic to the instances should only come from the ALB. 
- a. For ALB security group: Open port 80 for all incoming requests from the internet. 
- b. For EC2 instances security group: open the port 80 from the application load balancer to the EC2 instance. Create a security group ingress rule to allow traffic only from the ALB. Set the source to ALB security group.
2. Create two ec2 instances with instance type "t2.micro" each with a different subnet id to spread them between two different availability zones. Choose the EC2 security group created in step 1. And use the shell script "script.sh" under scripts folder for EC2 instances user data.
3. Create a target group of target_type = "instance".
4. Configure Application Load Balancer
- a. Select the VPC & the 2 Subnets. 
- b. Select the target group for your load balancer.
5. Register the two EC2 instances to the target group and attach them to the group.


## How to test the setup?
Run "terraform apply" to deploy the resources. Copy the "alb_hostname" value from the output.

1. Check the load balancer: Open a new tab in your web browser and paste the DNS name of the load balancer. You should see the web page which says "Hello World from ip-172-31-3-166.ec2.internal". If you see this page, then the configuration is working.

- 172.31.3.166  is the private IPv4 address of one of the ec2 instances.

2. Wait for few minutes. If you use the ALB DNS that you copied earlier to access and refresh the web page, you can see that it is hosting the web page in another ec2 instance. You can check this when the private IPv4 address changes in the webpage. 
- For example: It changes from "Hello World from ip-172-31-3-166.ec2.internal" to "Hello World from ip-172-31-4-146.ec2.internal".

- Note: This is because routing algorithms in ALB target groups behave Round Robin by default.



