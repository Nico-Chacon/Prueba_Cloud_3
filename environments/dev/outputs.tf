output "alb_dns_name" {
  description = "DNS del Application Load Balancer — pegar en el browser para ver la app"
  value       = module.loadbalancer.alb_dns_name
}

output "vpc_id" {
  description = "ID de la VPC"
  value       = module.networking.vpc_id
}

output "db_endpoint" {
  description = "Endpoint de RDS MySQL"
  value       = module.database.db_endpoint
}

output "asg_name" {
  description = "Nombre del Auto Scaling Group"
  value       = module.compute.asg_name
}

output "sns_topic_arn" {
  description = "ARN del topic SNS para alertas"
  value       = module.monitoring.sns_topic_arn
}

output "cloudtrail_bucket" {
  description = "Bucket S3 con logs de auditoría CloudTrail"
  value       = module.cloudtrail.log_bucket_name
}

output "cloudtrail_trail_name" {
  description = "Nombre del Trail de CloudTrail"
  value       = module.cloudtrail.trail_name
}

#output "auditor_role_arn" {
#  description = "ARN del rol IAM de auditor"
#  value       = module.governance.auditor_role_arn
#}

#output "budget_monthly_name" {
#  description = "Nombre del presupuesto mensual configurado"
#  value       = module.budgets.budget_monthly_name
#}
