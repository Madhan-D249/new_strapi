
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2" # Change to your desired region
}

variable "ami_id" {
  description = "AMI ID to use for the instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Name of the key pair"
  type        = string
}

