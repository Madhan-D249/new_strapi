variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "container_image" {
  description = "Docker image URL for the Strapi application"
  type        = string
}

variable "app_keys" {
  description = "Strapi application keys"
  type        = string
  sensitive   = true
}

variable "admin_jwt_secret" {
  description = "Strapi admin JWT secret"
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "Strapi user JWT secret"
  type        = string
  sensitive   = true
}

variable "api_token_salt" {
  description = "Strapi API token salt"
  type        = string
  sensitive   = true
}

variable "task_role_arn" {
  description = "IAM role ARN for the ECS task"
  type        = string
}

variable "execution_role_arn" {
  description = "IAM role ARN for ECS task execution"
  type        = string
}

# ✅ Add these for DB connection

variable "database_client" {
  description = "Database client type (e.g. postgres)"
  type        = string
  default     = "postgres"
}

variable "database_port" {
  description = "Database port"
  type        = string
  default     = "5432"
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "database_username" {
  description = "Database username"
  type        = string
}

variable "database_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}
