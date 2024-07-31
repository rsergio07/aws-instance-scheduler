variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}

variable "instance_ami" {
  description = "The AMI to use for the instance."
  type        = string
  default     = "ami-03972092c42e8c0ca"
}

variable "instance_type" {
  description = "The instance type of the EC2 instance."
  type        = string
  default     = "t2.micro"
}

variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
  default     = "my-shared-bucket-k098wkg378t47ti"
}
