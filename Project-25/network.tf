# ALB Security Group: Edit to restrict access to the application
resource "aws_security_group" "lb_sg" {
   name        = "app-ALB-sg"
   description = "app-ALB-sg"
   vpc_id      = var.default_vpc_id
 
   ingress {
     protocol    = "tcp"
	     from_port   = 80
     to_port     = 80
     cidr_blocks = ["0.0.0.0/0"]
   }
 
   egress {
     protocol    = "-1"
     from_port   = 0
     to_port     = 0
     cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "test" {
   name               = "app-ALB"
   internal           = false
   load_balancer_type = "application"
   ip_address_type    = "ipv4"
   security_groups    = [aws_security_group.lb_sg.id]
   subnets            = [var.public_subnet1_id, var.public_subnet2_id]
 
 }
 

 resource "aws_lb_target_group" "alb-example" {
   name        = "app-TG"
   target_type = "ip"
   port     = 80
   protocol = "HTTP"
   vpc_id      = var.default_vpc_id
   protocol_version = "HTTP1"
 }
 
 resource "aws_lb_listener" "front_end" {
   load_balancer_arn = aws_lb.test.arn
   port              = "80"
   protocol          = "HTTP"
 
   default_action {
     type             = "forward"
     target_group_arn = aws_lb_target_group.alb-example.arn
   }
}

# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  name        = "myapp-ecs-tasks-security-group"
  description = "allow inbound access from the ALB only"
  vpc_id      = var.default_vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}