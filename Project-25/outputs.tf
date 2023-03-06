 output "alb_hostname" {
   value = aws_lb.test.dns_name
 }

 output "Web_alb_id" {
   value = aws_lb.test.id
 }

 output "target_group_name" {
   value = aws_lb_target_group.alb-example.name
 }

 output "ecs_cluster_name" {
   value = aws_ecs_cluster.app.name
 }

 output "ecs_service_name" {
   value = aws_ecs_service.sample_app.name
 }