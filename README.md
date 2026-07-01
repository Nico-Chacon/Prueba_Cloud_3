# TechNova Solutions — EP3 ARY1101
## Gestión de Costos y Gobierno Cloud en AWS

Infraestructura como código (Terraform) para la EP3 de Infraestructura Cloud II (DuocUC 2025).  
Extiende la infraestructura de alta disponibilidad de EP2 con **control financiero** y **gobierno cloud**.

---

## Módulos incluidos

| Módulo       | Descripción                                              | EP  |
|-------------|----------------------------------------------------------|-----|
| networking   | VPC, subnets, NAT Gateway, Internet Gateway              | EP2 |
| security     | Security Groups para ALB, EC2 y RDS                     | EP2 |
| compute      | EC2 Auto Scaling Group + Launch Template (t3.small gp3) | EP2 |
| loadbalancer | Application Load Balancer + Target Group                 | EP2 |
| database     | RDS MySQL 8.0 Multi-AZ (db.t4g.small, 50GB gp3)        | EP2 |
| monitoring   | CloudWatch Alarms + SNS + Dashboard                      | EP2 |
| **budgets**  | **AWS Budgets con alertas 60/70/80/100% vía SNS**       | EP3 |
| **cloudtrail** | **Auditoría de eventos + S3 para logs**               | EP3 |
| **governance** | **IAM roles, política de tagging obligatorio**        | EP3 |

## Estándar de Tagging (EP3)

Todos los recursos del repo llevan los siguientes tags obligatorios:

| Tag         | Valor          | Propósito                        |
|-------------|----------------|----------------------------------|
| Project     | technova       | Identificar el proyecto          |
| Environment | dev            | Ambiente (dev/prod)              |
| Owner       | cloud-team     | Responsable técnico              |
| CostCenter  | ecommerce      | Centro de costos para facturación|
| ManagedBy   | terraform      | Trazabilidad IaC                 |
| CreatedDate | 2025-01        | Fecha de creación                |

## Control Financiero (EP3)

| Presupuesto        | Límite mensual | Alertas configuradas      |
|--------------------|---------------|--------------------------|
| Total cuenta       | $100 USD       | 60%, 70%, 80%, 100%, forecast |
| Solo EC2           | $40 USD        | 80%                      |
| Solo RDS           | $30 USD        | 80%                      |

Todas las alertas se envían vía **SNS** al correo configurado en `email_sns`.

## Estructura del repositorio

```
.
├── environments/
│   └── dev/
│       ├── main.tf           # Orquestación de todos los módulos
│       ├── variables.tf      # Variables con presupuestos EP3
│       ├── outputs.tf        # Outputs incluyendo CloudTrail y Budgets
│       ├── terraform.tfvars  # Valores reales (no subir contraseñas)
│       ├── backend.tf        # Estado remoto en S3
│       └── providers.tf      # Provider AWS
├── modules/
│   ├── networking/           # VPC y red
│   ├── security/             # Security Groups
│   ├── compute/              # EC2 ASG
│   ├── loadbalancer/         # ALB
│   ├── database/             # RDS MySQL
│   ├── monitoring/           # CloudWatch + SNS
│   ├── budgets/              # AWS Budgets (EP3)
│   ├── cloudtrail/           # CloudTrail auditoría (EP3)
│   └── governance/           # IAM roles y tagging (EP3)
└── scripts/
    └── user-data.sh          # Bootstrap EC2 con Docker + Nginx
```
![Miau](miau.jpg)