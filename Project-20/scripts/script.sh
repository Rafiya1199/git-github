#!/bin/bash
# Use this for your user data
yum -y update
yum -y install nfs-utils   
mkdir ~/efs-mount-point
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-00fc0f6926ddf4486.efs.us-east-1.amazonaws.com:/ ~/efs-mount-point

 
