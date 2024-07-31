# AWS Infrastructure Deployment with Terraform

This project provides a Terraform configuration to deploy a robust and cost-effective AWS infrastructure. The setup includes EC2 instances, a VPC, subnets, security groups, and an AWS Instance Scheduler to manage the lifecycle of EC2 instances.

## Project Description

This project aims to automate the deployment and management of AWS resources using Terraform. The infrastructure includes:

- **4 EC2 Instances**: 
  - 2 Web Server instances are scheduled to automatically shut down every Thursday at 6 p.m. and start every Wednesday at 6 a.m. using AWS Instance Scheduler.
  - 2 Database instances that remain active 24/7.
- **AWS Instance Scheduler**: Automates the start and stop times of the web server instances to optimize costs.
- **VPC and Subnets**:
  - Public subnets for web server instances.
  - Private subnets for database instances.
- **Security Groups**: Configured to allow necessary traffic.

## Prerequisites

- Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- Configure AWS CLI: `aws configure`

## Files

- `variables.tf`: Defines the variables used in the configurations.
- `main.tf`: Main Terraform configuration file.

## Steps to Deploy

1. **Initialize Terraform**:
    ```sh
    terraform init
    ```

2. **Format the Configuration**:
    ```sh
    terraform fmt
    ```

3. **Validate the Configuration**:
    ```sh
    terraform validate
    ```

4. **Plan the Deployment**:
    ```sh
    terraform plan
    ```

5. **Apply the Deployment**:
    ```sh
    terraform apply
    ```

6. **Verify Resources**:
    ```sh
    terraform show
    ```

7. **Destroy the Infrastructure (when needed)**:
    ```sh
    terraform destroy -auto-approve
    ```

## Monitoring and Validation

### Using AWS CLI
To check the status of your EC2 instances daily:
```sh
aws ec2 describe-instances --query 'Reservations[*].Instances[*].{Instance:InstanceId,State:State.Name,Name:Tags[?Key==`Name`].Value|[0]}' --output table
