# S3 Event Driven app

This S3 event-driven app uses the principle of decoupling, least-privilege access, and data encryption. There are three operations in this app. First of all, after building cloud resources from terraform, run addIamUserToDataBase lambda to create a new IAM user in the rds server. Once the IAM user account is set properly, the user can perform Django migrations to update tables in the rds. Lastly, to trigger the S3 event, upload the CSV file to the S3 bucket, the S3 bucket will notify the sqs queue with an event body that contains information about the CSV file, and csvToDataBase lambda will process the CSV and update the corresponding rds table. 

<p align="center"> 
  <img src="./assets/event-driven-app-diagram.png" />
</p>

## Architecture

## Run locally
### Prerequisites
* [AWS CLI Setup](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
* [VS Code Dev Containers Setup](https://code.visualstudio.com/docs/devcontainers/containers)
* [Setup IAM user](https://dev.to/aws-builders/creating-your-first-iam-admin-user-and-user-group-in-your-aws-account-machine-learning-part-1-3cne)

## Steps to go from starter to completed
If you want to take the starter project and implement real-time functionality on your own to learn and get hands-on, here are some guidelines:


## Some good readings for better understanding
### IAM
[IAM: What happens when you assume a role](https://www.tecracer.com/blog/2021/08/iam-what-happens-when-you-assume-a-role.html)

### Terraform & Serverless
[Deploy Terraform & Serverless Framework in Perfect Harmony](https://medium.com/johnveldboom/deploy-terraform-serverless-framework-in-perfect-harmony-948ab6dcbc78)

### S3
[VPCe + S3 deployment using Terraform](https://dev.to/aws-builders/vpce-s3-deployment-using-terraform-12n0)

## Future development