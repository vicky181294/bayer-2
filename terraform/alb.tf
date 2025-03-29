# Load Balancer
resource "aws_lb" "ecs_alb" {
  name               = "ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id]
}

# ALB Target Groups for each service
resource "aws_lb_target_group" "ecs_tg" {
  for_each = {
    for svc in var.ecs_services :
    svc.name => svc
  }

  name        = "${each.value.name}-tg-${var.env}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.my_vpc.id
  target_type = "ip"
}