aws_region   = "us-east-1"
project_name = "technova"
vpc_cidr     = "10.0.0.0/16"

# REEMPLAZAR después de crear la AMI desde la consola AWS
ami_id = ""

# Contraseña para RDS (mínimo 8 caracteres)
db_password = "Chacon2025!Secure"

# Tu correo para notificaciones SNS (confirmar el email que llega)
email_sns = "gab.chacon@duocuc.cl"

# Versión de la aplicación
app_version = "v1.0.0"

# ----------------------------------------------------------
# EP3: Presupuestos mensuales en USD
# ----------------------------------------------------------
monthly_budget_usd = "100"   # Presupuesto total de la cuenta
ec2_budget_usd     = "40"    # Solo instancias EC2
rds_budget_usd     = "30"    # Solo base de datos RDS
