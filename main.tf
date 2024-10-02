terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "nest-ecs-patient-tfstate-bucket" // bucket name
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "nest-ecs-patient-terraform-lock-state" // dynamodb table name
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

resource "aws_lb_target_group" "patient_target_group" {
  name        = "patient-target-group"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.default_vpc_id # default VPC
  health_check {
    path                = "/patient/health"
    protocol            = "HTTP"
    port                = "3000"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "patient_rule" {
  listener_arn = var.alb_lb_listener_rule_arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.patient_target_group.arn
  }
  condition {
    path_pattern {
      values = ["/patient/*"]
    }
  }
}

resource "aws_ecs_service" "patient_service" {
  name            = "patient-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.organization_task.arn
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.organization_target_group.arn
    container_name   = "nest-ecr-organization"
    container_port   = 3000
  }

  network_configuration {
    subnets          = [var.default_subnet_a_id, var.default_subnet_b_id]
    security_groups  = [var.ecs_service_sg_id]
    assign_public_ip = true
  }

  launch_type = "FARGATE"
}

resource "aws_ecs_task_definition" "patient_task" {
  family                   = "nest-ecs-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.ecs_task_execution_role_arn

  container_definitions = <<DEFINITION
  [
    {
      "name": "nest-ecr-patient",
      "image": "${var.container_image}",
      "cpu": 256,
      "memory": 512,
      "essential": true,
      "portMappings": [
        {
          "containerPort": 3000,
          "protocol": "tcp"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/nest-ecs-patient",
          "awslogs-region": "eu-west-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
  DEFINITION
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/nest-ecs-patient"
  retention_in_days = 7
}
