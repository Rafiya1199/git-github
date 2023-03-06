# TCF39 - Create EFS Volume and attach it to an EC2 instance

## Steps

## Prerequisites: Create a new VPC (or use an existing vpc) and a public subnet

1. Create a security group for EC2 instance and a security group for EFS volume. Traffic to the EFS volume should only come from the ec2 instance.
2. Create a EFS volume
3. Create an efs mount target. A mount target provides an IP address for an NFSv4 endpoint at which you can mount an Amazon EFS file system.
4. Create an EC2 instance of instance type "t2.micro" and select the vpc, subnet and security group created above.

## Manual steps to attach the EFS volume

1. Connect the ec2 instance through session manager.

2. After connecting to session manager, enter cd ~. And then create a folder /efs with the command: sudo mkdir /efs

3. Copy your file system id from the output.

4. Replace the <file_system_id> and use the following command to attach the file system to ec2 instance.

- `sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport <file_system_id>.efs.us-east-1.amazonaws.com:/ /efs`

5. To make Mount Permanent, add an entry with <file_system_id> in /etc/fstab to allow auto mount after reboot. To do this Run the following commands after updating <file_system_id>:

- (Change permissions of /etc/fstab): sudo chmod 777 /etc/fstab
- `sudo echo <file_system_id>.efs.us-east-1.amazonaws.com:/ /efs nfs4 defaults,_netdev 0 0  | sudo cat >> /etc/fstab`

## How to test the setup?

Run the command: "df -h". The df command is used to show the amount of disk space that is free on file systems. If the EFS volume is attached you should see, for example:

- fs-0115859dfba4984a5.efs.us-east-1.amazonaws.com:/  8.0E     0  8.0E   0% /efs
