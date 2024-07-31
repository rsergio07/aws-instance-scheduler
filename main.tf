provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Public Subnets
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

# Private Subnets
resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1c"
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1d"
}

# Security Groups
resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg-"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_sg" {
  name_prefix = "db-sg-"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instances - Web Servers
resource "aws_instance" "web" {
  count             = 2
  ami               = var.instance_ami
  instance_type     = var.instance_type
  availability_zone = element(["us-east-1a", "us-east-1b"], count.index)
  tags = {
    Name     = "WebServer${count.index + 1}"
    Schedule = "webserver-schedule"
  }

  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id              = element([aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id], count.index)
}

# EC2 Instances - DB Servers
resource "aws_instance" "db" {
  count             = 2
  ami               = var.instance_ami
  instance_type     = var.instance_type
  availability_zone = element(["us-east-1c", "us-east-1d"], count.index)
  tags = {
    Name = "DBServer${count.index + 1}"
  }

  vpc_security_group_ids = [aws_security_group.db_sg.id]
  subnet_id              = element([aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id], count.index)
}

# CloudFormation Stack for AWS Instance Scheduler
resource "aws_cloudformation_stack" "instance_scheduler" {
  name         = "InstanceScheduler"
  template_url = "https://my-shared-bucket-k098wkg378t47ti.s3.amazonaws.com/instance-scheduler-on-aws.template"
  parameters = {
    TagName                = "Schedule"
    SchedulerFrequency     = "5"
    DefaultTimezone        = "UTC"
    LogRetentionDays       = "30"
    Trace                  = "No"
    OpsMonitoring          = "Enabled"
    MemorySize             = "128"
    AsgMemorySize          = "128"
    OrchestratorMemorySize = "128"
    ddbDeletionProtection  = "Enabled"
  }

  capabilities = ["CAPABILITY_NAMED_IAM"]
}
