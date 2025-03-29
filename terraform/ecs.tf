resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.domain}-cluster-${var.env}"

  setting {
    name  = "containerInsights"
    value = "enhanced"
  }
  tags = local.default_tags
}

# Create ECR repositories dynamically for each service
resource "aws_ecr_repository" "ECR_registry" {
  for_each = {
    for svc in var.ecs_services :
    svc.name => svc
  }

  name                 = "${var.env}/${var.domain}/${each.value.name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.default_tags
}

# Create task definitions dynamically for multiple ECS services
data "template_file" "task_definition" {
  for_each = {
    for svc in var.ecs_services :
    svc.name => svc
  }

  template = file("${path.module}/task-definition-${var.domain}-${each.value.name}.json")

  vars = {
    image_url        = "${aws_ecr_repository.ECR_registry[each.value.name].repository_url}:latest"
    container_name   = "${each.value.name}-container-${var.env}"
    log_group_region = var.aws_region
    log_group_name   = var.log_group_name
    log_strm_prefix  = var.domain
    cpu              = each.value.cpu
    memory           = each.value.memory
    env              = var.env
  }
}

# IAM role for task execution
data "aws_iam_role" "ecs_execution_role" {
  name = var.ECSTaskExecution_role
}

# Create ECS Task Definitions dynamically
resource "aws_ecs_task_definition" "task_definitions" {
  for_each = {
    for svc in var.ecs_services :
    svc.name => svc
  }

  family                   = "${var.domain}-${each.value.name}-task-${var.env}"
  container_definitions    = data.template_file.task_definition[each.value.name].rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  execution_role_arn       = data.aws_iam_role.ecs_execution_role.arn
  task_role_arn            = data.aws_iam_role.ecs_execution_role.arn
}

# Create ECS Services dynamically
resource "aws_ecs_service" "services" {
  for_each = {
    for svc in var.ecs_services :
    svc.name => svc
  }

  name            = "abg-dataaccess-${each.value.name}-service-${var.env}"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definitions[each.value.name].arn
  desired_count   = each.value.desired_count
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg[each.value.name].arn
    container_name   = "${each.value.name}-container-${var.env}"
    container_port   = 80
  }

  network_configuration {
    subnets          = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  tags = local.default_tags

}
