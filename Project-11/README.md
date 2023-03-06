# TCF - EKS

## Steps:
1. Install and update kubectl

2. Create an IAM role and attach Amazon EKS managed IAM policy: AmazonEKSClusterPolicy to the role

3. Create a Amazon VPC with public and private subnets that meets Amazon EKS requirements.

4. Then, create an Amazon EKS cluster

5. Configure the computer to communicate with the cluster. Create a kubeconfig file for the cluster. The settings in this file enable the kubectl CLI to communicate with your cluster. Run the following command:

- aws eks update-kubeconfig --region region-code --name my-cluster

6. To create nodes of type: Fargate linux, a Fargate profile should be created and Amazon EKS pod execution IAM role should also be created, which has the policy: AmazonEKSFargatePodExecutionRolePolicy attached. When creating a Fargate profile, correct details should be entered for Namespace and Match labels as  nodes are deployed based on the Fargate profile label.

7. Deploy a sample application on the cluster. This sample deployment pulls a container image from a public repository and deploys 2 replicas (individual pods) of it to the cluster.

## References:
https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html

a. Create a namespace. A namespace allows you to group resources in Kubernetes. If you plan to deploy your sample application to AWS Fargate, make sure that the value for namespace in your AWS Fargate profile is eks-sample-app. Run the following command:
- kubectl create namespace eks-sample-app

b. Create a Kubernetes deployment. Use the file: eks-sample-deployment.yaml for deployment. Run the following command:
- kubectl apply -f eks-sample-deployment.yaml

8. Also create a service which allows to access all replicas through a single IP address or name. Use the file: eks-sample-service.yaml for creating the service. Run the following command:
- kubectl apply -f eks-sample-service.yaml

## Verification:
1. To view all resources that exist in the eks-sample-app namespace, run the following command:
- kubectl get all -n eks-sample-app

2. To view the details of the deployed service, run the following command:
- kubectl -n eks-sample-app describe service eks-sample-linux-service

3. To view the details of one of the pods listed in the output when you viewed the namespace in a previous step, replace 776d8f8fd8-78w66 in the below command with the value returned for one of your pods and run it:
- kubectl -n eks-sample-app describe pod eks-sample-linux-deployment-65b7669776-m6qxz

4. The deployment is also verified by running a shell on one of the pods with its ID. From the pod shell, we can view the output from the web server that was installed with the deployment. 

a. Run a shell on the pod that you described in the previous step, replacing 65b7669776-m6qxz in the below command with the ID of one of your pods.
- kubectl exec -it eks-sample-linux-deployment-65b7669776-m6qxz -n eks-sample-app -- /bin/bash

b. From the pod shell, view the output from the web server that was installed with your deployment in a previous step.
- We can either use “curl <IP address>” or “curl <service name>”

