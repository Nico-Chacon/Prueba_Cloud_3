# ============================================================
# TechNova Solutions — EP3 ARY1101
# Gestión de Costos y Gobierno Cloud en AWS
# ============================================================

# Tags comunes obligatorios — se aplican a TODOS los recursos
locals {
  common_tags = {
    Project     = var.project_name
    Environment = "dev"
    Owner       = "cloud-team"
    CostCenter  = "ecommerce"
    ManagedBy   = "terraform"
    CreatedDate = "2025-01"
  }
}

# Obtener el account ID actual (necesario para CloudTrail bucket)
data "aws_caller_identity" "current" {}

# ----------------------------------------------------------
# MÓDULO: Networking
# ----------------------------------------------------------
module "networking" {
  source       = "../../modules/networking"
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
}

# ----------------------------------------------------------
# MÓDULO: Security Groups
# ----------------------------------------------------------
module "security" {
  source = "../../modules/security"
  vpc_id = module.networking.vpc_id
}

# ----------------------------------------------------------
# MÓDULO: Base de Datos RDS MySQL Multi-AZ
# ----------------------------------------------------------
module "database" {
  source       = "../../modules/database"
  project_name = var.project_name
  vpc_id       = module.networking.vpc_id
  db_subnets   = module.networking.private_subnets_data
  rds_sg_id    = module.security.rds_sg_id
  db_password  = var.db_password
}

# ----------------------------------------------------------
# MÓDULO: Application Load Balancer
# ----------------------------------------------------------
module "loadbalancer" {
  source         = "../../modules/loadbalancer"
  project_name   = var.project_name
  vpc_id         = module.networking.vpc_id
  public_subnets = module.networking.public_subnets
  alb_sg_id      = module.security.alb_sg_id
}

# ----------------------------------------------------------
# MÓDULO: Compute (EC2 ASG + Launch Template)
# ----------------------------------------------------------
module "compute" {
  source           = "../../modules/compute"
  project_name     = var.project_name
  vpc_id           = module.networking.vpc_id
  private_subnets  = module.networking.public_subnets
  target_group_arn = module.loadbalancer.target_group_arn
  ec2_sg_id        = module.security.ec2_sg_id
  ami_id           = var.ami_id
  app_version      = var.app_version
}

# ----------------------------------------------------------
# MÓDULO: Monitoreo CloudWatch + SNS
# ----------------------------------------------------------
module "monitoring" {
  source         = "../../modules/monitoring"
  project_name   = var.project_name
  asg_name       = module.compute.asg_name
  alb_arn_suffix = module.loadbalancer.alb_arn_suffix
  db_identifier  = module.database.db_identifier
  email_sns      = var.email_sns
  instance_ids   = module.compute.instance_ids
}

# ----------------------------------------------------------
# MÓDULO: AWS Budgets — Control financiero con alertas SNS
# EP3 NUEVO: presupuestos con umbrales 60/70/80/100%
# ----------------------------------------------------------
# module "budgets" {
#  source             = "../../modules/budgets"
#  project_name       = var.project_name
#  monthly_budget_usd = var.monthly_budget_usd
#  ec2_budget_usd     = var.ec2_budget_usd
#  rds_budget_usd     = var.rds_budget_usd
#  sns_topic_arn      = module.monitoring.sns_topic_arn
#}

# ----------------------------------------------------------
# MÓDULO: CloudTrail — Auditoría y trazabilidad
# EP3 NUEVO: registro de todos los eventos de la cuenta
# ----------------------------------------------------------
module "cloudtrail" {
  source       = "../../modules/cloudtrail"
  project_name = var.project_name
  account_id   = data.aws_caller_identity.current.account_id
  common_tags  = local.common_tags
}

# ----------------------------------------------------------
# MÓDULO: Governance — IAM roles y política de tagging
# EP3 NUEVO: roles de auditor y política de tags obligatorios
# ----------------------------------------------------------
# module "governance" {
#  source       = "../../modules/governance"
#  project_name = var.project_name
#  common_tags  = local.common_tags
#}

# Backup module disabled - AWS Academy no soporta IAM roles para Backup
# module "backup" {
#   source           = "../../modules/backup"
#   project_name     = var.project_name
#   ec2_instance_ids = module.compute.instance_ids
#   rds_db_arn       = module.database.db_arn
# }
