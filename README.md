# AWS Infrastructure Deployment with Terraform

This repository contains Terraform configurations to deploy AWS infrastructure including EC2 instances, VPC, subnets, security groups, and the AWS Instance Scheduler.

## Prerequisites

- Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- Configure AWS CLI: `aws configure`

## Files

- `variables.tf`: Defines the variables used in the configurations.
- `main.tf`: Main Terraform configuration file.
- `instance-scheduler-on-aws.template`: CloudFormation template for AWS Instance Scheduler (uploaded to your S3 bucket).

## Steps to Deploy

1. Initialize Terraform:
    ```sh
    terraform init
    ```

2. Format the Configuration:
    ```sh
    terraform fmt
    ```

3. Validate the configuration:
    ```sh
    terraform validate
    ```

4. Plan the deployment:
    ```sh
    terraform plan
    ```

5. Apply the deployment:
    ```sh
    terraform apply
    ```

6. Verify Resources:
    ```sh
    terraform show
    ```

7. Destroy the Infrastructure (when needed):
    ```sh
    terraform destroy -auto-approve
    ```

## Managing the Infrastructure

- To update the infrastructure, modify the `main.tf` or other configuration files, then run:
    ```sh
    terraform apply
    ```

- To destroy the infrastructure, run:
    ```sh
    terraform destroy -auto-approve
    ```

## Notes

- The web instances are scheduled to automatically shut down every Thursday at 6 p.m. and start every Wednesday at 6 a.m. using AWS Instance Scheduler.
- The DB instances remain active 24/7 and are hosted in a private subnet.
- All instances can access a shared S3 bucket.

