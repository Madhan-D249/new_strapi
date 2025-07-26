provider "aws" {
  region = var.region
}

data "aws_vpc" "default" {
  default = true
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "madhan_log_group" {
  name              = "/ecs/madhan-strapi-app"
  retention_in_days = 7
}

# Security Group
resource "aws_security_group" "madhan_sg" {
  name        = "madhan-sg"
  description = "Allow HTTP, Strapi and PostgreSQL"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "madhan-sg"
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "strapi_db_subnet_group" {
  name       = "strapi-db-subnet-group-vetty"
  subnet_ids = ["subnet-0c0bb5df2571165a9", "subnet-0cc2ddb32492bcc41"]
}

# DB Parameter Group to disable SSL
resource "aws_db_parameter_group" "strapi_pg" {
  name        = "strapi-db-pg"
  family      = "postgres12"
  description = "Strapi DB parameter group with SSL disabled"

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }
}

# RDS PostgreSQL
resource "aws_db_instance" "strapi_db" {
  identifier              = "strapi-db"
  engine                  = "postgres"
  engine_version          = "12.22"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = var.db_name
  username                = var.database_username
  password                = var.database_password
  publicly_accessible     = true
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.madhan_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.strapi_db_subnet_group.name
  parameter_group_name    = aws_db_parameter_group.strapi_pg.name
}

# ALB
resource "aws_lb" "madhan_strapi_alb" {
  name               = "madhan-strapi-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.madhan_sg.id]
  subnets            = ["subnet-0c0bb5df2571165a9", "subnet-0cc2ddb32492bcc41"]

  tags = {
    Name = "madhan-strapi-alb"
  }
}

# Target Group
resource "aws_lb_target_group" "madhan_strapi_tg" {
  name        = "madhan-strapi-tg"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

# Listener
resource "aws_lb_listener" "madhan_listener" {
  load_balancer_arn = aws_lb.madhan_strapi_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.madhan_strapi_tg.arn
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "madhan_strapi_cluster" {
  name = "madhan-strapi-cluster"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "madhan_strapi_task" {
  family                   = "madhan-strapi-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([{
    name      = "madhan-strapi"
    image     = var.container_image
    essential = true
    portMappings = [{
      containerPort = 1337
      hostPort      = 1337
    }]
    environment = [
      { name = "DATABASE_CLIENT",      value = "postgres" },
      { name = "DATABASE_HOST",        value = aws_db_instance.strapi_db.address },
      { name = "DATABASE_PORT",        value = "5432" },
      { name = "DATABASE_NAME",        value = var.db_name },
      { name = "DATABASE_USERNAME",    value = var.database_username  },
      { name = "DATABASE_PASSWORD",    value = var.database_password  },
      { name = "APP_KEYS",             value = var.app_keys },
      { name = "ADMIN_JWT_SECRET",     value = var.admin_jwt_secret },
      { name = "JWT_SECRET",           value = var.jwt_secret },
      { name = "API_TOKEN_SALT",       value = var.api_token_salt }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.madhan_log_group.name
        awslogs-region        = var.region
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}

# ECS Service
resource "aws_ecs_service" "madhan_strapi_service" {
  name            = "madhan-strapi-service"
  cluster         = aws_ecs_cluster.madhan_strapi_cluster.id
  task_definition = aws_ecs_task_definition.madhan_strapi_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = ["subnet-0c0bb5df2571165a9", "subnet-0cc2ddb32492bcc41"]
    assign_public_ip = true
    security_groups  = [aws_security_group.madhan_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.madhan_strapi_tg.arn
    container_name   = "madhan-strapi"
    container_port   = 1337
  }

  depends_on = [
    aws_lb_listener.madhan_listener,
    aws_db_instance.strapi_db
  ]
}
