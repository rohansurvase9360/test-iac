terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-1"
}

# Load Balancer
resource "aws_lb" "iac_test_lb" {
  name               = "iac-test"
  load_balancer_type = "application" # Optional. Defaults to application
}

# HTTPS Listener with ACM Certificate (Primary)
resource "aws_lb_listener" "https_primary_listener" {
  load_balancer_arn = aws_lb.iac_test_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:860454016470:certificate/322f8694-62f9-4e5a-b0ac-2e78dcc68e7c"

  default_action {
    type = "forward"
  }
}

# HTTPS Listener with ACM Certificate (Secondary)
resource "aws_lb_listener" "https_secondary_listener" {
  load_balancer_arn = aws_lb.iac_test_lb.arn
  port              = 444
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:860454016470:certificate/322f8694-62f9-4e5a-b0ac-2e78dcc68e7c"

  default_action {
    type = "forward"
  }
}

# HTTP Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.iac_test_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
  }
}

# HTTPS Listener without ACM Certificate
resource "aws_lb_listener" "https_no_cert_listener" {
  load_balancer_arn = aws_lb.iac_test_lb.arn
  port              = 445
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "forward"
  }
}
