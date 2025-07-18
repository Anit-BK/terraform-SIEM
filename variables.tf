variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "Instance type for EC2"
  default     = "t3.medium"
}


variable "ami_id" {
  description = "AMI ID for RedHat Enterprise Linux"
  default     = "ami-0c02fb55956c7d316" # RHEL 8 in us-east-1
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    Environment = "Dev"
    Project     = "SIEM-Platform"
  }
}

