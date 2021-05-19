resource "aws_alb" "atif-ext-alb" {
    name               = "atif-ext-alb-${terraform.workspace}"
    internal           = false
    load_balancer_type = "application"
    security_groups    = var.alb-ext-sg
    subnets            = var.public_subnet

    enable_deletion_protection = false

    tags = {
      "Name" = "atif-ext-alb-${terraform.workspace}"
    }
}

resource "aws_lb_target_group_attachment" "atif-alb-tg-web-1" {
  target_group_arn = aws_lb_target_group.atif-ext-alb-tg.arn
  target_id        = var.ec2-web-1
  port             = 80
}
resource "aws_lb_target_group_attachment" "atif-alb-tg-web-2" {
  target_group_arn = aws_lb_target_group.atif-ext-alb-tg.arn
  target_id        = var.ec2-web-2
  port             = 80
}


resource "aws_lb_target_group" "atif-ext-alb-tg" {
  name     = "atif-ext-alb-tg-${terraform.workspace}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/index.html"
    port = 80
    healthy_threshold = 6
    unhealthy_threshold = 5
    timeout = 4
    interval = 10
    matcher = "200,302"  # has to be HTTP 200 or fails
  }
}

resource "aws_lb_listener" "atif-ext-alb-listener" {
  load_balancer_arn = aws_alb.atif-ext-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.atif-ext-alb-tg.arn
  }
}
