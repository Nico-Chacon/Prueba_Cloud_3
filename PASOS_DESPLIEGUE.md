# Guía de Despliegue — Chacon | ARY1101

## PASO 1 — Preparar AWS Academy

1. Inicia tu Learner Lab en AWS Academy
2. Copia las credenciales (AWS Details → AWS CLI):
   - `aws_access_key_id`
   - `aws_secret_access_key`
   - `aws_session_token`

## PASO 2 — Crear recursos previos (CloudShell en AWS)

Abre AWS CloudShell y ejecuta:

```bash
# Bucket para estado de Terraform
aws s3 mb s3://chacon-terraform-state --region us-east-1

# Tabla DynamoDB para locking
aws dynamodb create-table \
  --table-name chacon-terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

## PASO 3 — Subir repo a tu GitHub

```bash
# En tu PC
git clone https://github.com/maearaya221/INFRAESTRUCTURA_CLOUD_II_002D.git
# O descomprime el ZIP que tienes
cd chacon-PruebaCloud

# Crear tu propio repo en GitHub y subirlo
git init
git add .
git commit -m "Infraestructura TechNova - Chacon"
git remote add origin https://github.com/TU_USUARIO/chacon-PruebaCloud.git
git push -u origin main
```

## PASO 4 — Configurar Secrets en GitHub

En tu repo: **Settings → Secrets and variables → Actions → New repository secret**

| Nombre | Valor |
|--------|-------|
| `AWS_ACCESS_KEY_ID` | (de AWS Academy) |
| `AWS_SECRET_ACCESS_KEY` | (de AWS Academy) |
| `AWS_SESSION_TOKEN` | (de AWS Academy) |
| `EMAIL_SNS` | `gab.chacon@duocuc.cl` |

## PASO 5 — Primer despliegue (sin AMI)

Deja `ami_id = ""` en terraform.tfvars → Terraform usará Amazon Linux 2 por defecto.

Haz push a main → GitHub Actions ejecuta `terraform apply` automáticamente.

**Espera ~15 minutos** a que todo levante.

## PASO 6 — Crear tu AMI (IMPORTANTE para el informe)

1. En AWS Console → EC2 → Instances
2. Selecciona una de tus instancias levantadas
3. Actions → Image and templates → **Create image**
4. Nombre: `technova-ami-chacon`
5. Copia el AMI ID (ej: `ami-0abc123456789`)
6. Actualiza `terraform.tfvars`: `ami_id = "ami-0abc123456789"`
7. Haz commit+push → se redespliega con tu AMI

## PASO 7 — Confirmar email SNS

Revisa tu correo `gab.chacon@duocuc.cl` → confirma la suscripción SNS de AWS.

## PASO 8 — Tomar capturas para el informe

- [ ] Diagrama de arquitectura (ya tienes el del PDF)
- [ ] EC2 instances corriendo (2 instancias en diferentes AZ)
- [ ] ALB → DNS público funcionando en el browser
- [ ] Auto Scaling Group configurado
- [ ] RDS Multi-AZ activo
- [ ] CloudWatch Dashboard
- [ ] Alarmas configuradas
- [ ] Email SNS recibido
- [ ] AWS Backup configurado
- [ ] Prueba de falla: terminar EC2 → ver que ASG lanza nueva
- [ ] Restauración desde snapshot

## PASO 9 — Prueba de continuidad (para el informe 1.4)

```bash
# Desde AWS Console: EC2 → seleccionar una instancia → Instance State → Terminate
# Observar en Auto Scaling Group → Activity → cómo lanza una nueva
# El ALB sigue sirviendo tráfico con la instancia restante
```

## PASO 10 — Destruir al terminar (para no gastar créditos)

En GitHub: Actions → terraform-destroy → Run workflow → escribir "yes"
