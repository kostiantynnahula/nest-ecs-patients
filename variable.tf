variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "container_image" {
  type = string
  # default = "524147404421.dkr.ecr.eu-west-1.amazonaws.com/nest-ecr-organization:966d5f1-2024-09-26-11-37"
  default = "524147404421.dkr.ecr.eu-west-1.amazonaws.com/nest-ecr-patient:fc596b1-2024-10-02-06-08"
}

variable "cluster_id" {
  type    = string
  default = "arn:aws:ecs:eu-west-1:524147404421:cluster/nest-ecs-microservice-cluster"
}

variable "default_vpc_id" {
  type    = string
  default = "vpc-0636baa2b10378148"
}

variable "alb_lb_listener_rule_arn" {
  type    = string
  default = "arn:aws:elasticloadbalancing:eu-west-1:524147404421:listener/app/nest-ecs-alb/4acd1325b1627b57/1f568dd5334ac7c2"
}

variable "default_subnet_a_id" {
  type    = string
  default = "subnet-0f2628a3d03818748"
}

variable "default_subnet_b_id" {
  type    = string
  default = "subnet-054a31781cae0c6f9"
}

variable "ecs_service_sg_id" {
  type    = string
  default = "sg-086d6a3482e7f64e8"
}

variable "ecs_task_execution_role_arn" {
  type    = string
  default = "arn:aws:iam::524147404421:role/ecsTasksExecutionRole"
}
