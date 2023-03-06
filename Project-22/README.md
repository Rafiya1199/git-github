# TCF41 - Cloudwatch Alarm with EC2 instance

## How does it work?
- Create a Cloudwatch Alarm that terminates the EC2 instance if the CPU utilization reaches 100%.

CloudWatch Alarm is used to perform one or more actions based on the value of the metric or expression relative to a threshold over a number of time periods. In this task, Cloudwatch alarms can be used to take a particular EC2 instance action. We will terminate an EC2 instance when the alarm goes into “In Alarm” State.

## Steps
1. Create a security group, vpc (or use an existing vpc) and subnet for ec2 instance. 

2. Create an ec2 instance of type t2.micro.

3. Created a cloudwatch metric alarm with the required configuration to terminate the ec2 instance when the average CPU utilization reaches a certain value.

4. Test the configuration by installing a utility called stress. This tool is designed to subject the system to a configurable measure of CPU. This will generate the load. And as a result we can check if the alarm triggers the termination of ec2 instance.

## How to test the setup?
## Prerequisites
- Connect to the ec2 instance through session manager.

1. After connecting to session manager, run the following commands to install the stress utility:
- sudo amazon-linux-extras install epel -y
- sudo yum install stress -y
2. Then run the following command to generate CPU load:
- sudo stress --cpu 8
- Note: –cpu - This will spawn 8 CPU workers spinning on a square root task (sqrt(x))

3. Check the CloudWatch Alarms tab >> All alarms. Click on the Alarm named "ec2_cpuUtilization_alarm" and analyze the graph, history and actions tab. When the average CPU utilization of the instance is greater than the threshold value (for example 40%) for 2 periods of 2 minutes, i.e. 4 minutes, the Alarm status is changed from OK to "In alarm". As a result the EC2 instance will be terminated. Check the history tab and the ec2 console for verification.
