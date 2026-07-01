# Guía de Despliegue EP3 — TechNova | ARY1101

## PASO 1 — Iniciar AWS Academy Lab

1. Abre tu Learner Lab → clic en **Start Lab**
2. Espera que el círculo se ponga verde ✅
3. Clic en **AWS** para abrir la consola

---

## PASO 2 — Desplegar con Terraform

Si ya tienes el repo de EP2 desplegado, solo haz push con los cambios nuevos.  
Si partes de cero:

```bash
# En AWS CloudShell o tu terminal con credenciales configuradas
cd environments/dev
terraform init
terraform plan
terraform apply -auto-approve
```

**Espera ~10-15 minutos** para que todo levante.

---

## PASO 3 — Confirmar email SNS

Revisa tu correo `gab.chacon@duocuc.cl` y acepta la suscripción SNS.  
📸 **SCREENSHOT 1:** Email de confirmación SNS recibido + pantalla de "Subscription confirmed"

---

## PASO 4 — Screenshots para el Informe

### SECCIÓN 1.1 — Análisis Financiero

**Cost Explorer:**
1. Consola AWS → buscar "Cost Explorer" → clic en "Launch Cost Explorer"
2. Configurar vista: Monthly → Group by: Service
3. 📸 **SCREENSHOT 2:** Gráfico de barras con costo por servicio (EC2, RDS, EBS, ALB, Data Transfer)
4. Cambiar a vista "Daily" para ver tendencia
5. 📸 **SCREENSHOT 3:** Gráfico de tendencia diaria de los últimos 30 días

**AWS Pricing Calculator:**
1. Ir a https://calculator.aws/
2. Crear estimación → Add service → agregar:
   - EC2: t3.small Linux, 2 instancias, On-Demand, us-east-1
   - RDS: MySQL, db.t4g.small, Multi-AZ, 50GB gp3
   - ALB: 1 ALB, estimado de tráfico
   - EBS: 2x 50GB gp3
   - NAT Gateway: 2 gateways
3. 📸 **SCREENSHOT 4:** Resumen de estimación 1 mes en AWS Pricing Calculator
4. Exportar estimación (Share → copy link)
5. 📸 **SCREENSHOT 5:** Tabla de servicios con costos individuales

---

### SECCIÓN 1.2 — AWS Budgets + SNS

1. Consola AWS → buscar "Budgets" → AWS Budgets
2. Los presupuestos ya se crearon con Terraform. Ver la lista.
3. 📸 **SCREENSHOT 6:** Lista de presupuestos creados (monthly, ec2, rds)
4. Clic en el presupuesto mensual → ver detalle con los umbrales
5. 📸 **SCREENSHOT 7:** Detalle del presupuesto mensual con umbrales 60/70/80/100%
6. Clic en un umbral → ver configuración SNS
7. 📸 **SCREENSHOT 8:** Configuración de alerta con SNS topic vinculado

---

### SECCIÓN 1.3 — CloudTrail

1. Consola AWS → buscar "CloudTrail"
2. En "Trails" → ver el trail `technova-trail` creado por Terraform
3. 📸 **SCREENSHOT 9:** Lista de trails activos (mostrar "technova-trail")
4. Clic en el trail → ver configuración detallada
5. 📸 **SCREENSHOT 10:** Detalle del trail: multi-region ON, log validation ON, S3 bucket
6. Ir a "Event History" → ver eventos recientes registrados
7. 📸 **SCREENSHOT 11:** Lista de eventos en Event History (CreateBucket, RunInstances, etc.)
8. Clic en un evento para ver el detalle JSON
9. 📸 **SCREENSHOT 12:** Detalle JSON de un evento (quién hizo qué, desde dónde, cuándo)

---

### SECCIÓN 1.3 — IAM (Governance)

1. Consola AWS → IAM → Roles
2. Buscar "technova-auditor-role"
3. 📸 **SCREENSHOT 13:** Rol de auditor creado con sus políticas adjuntas
4. IAM → Policies → buscar "technova-require-tags-policy"
5. 📸 **SCREENSHOT 14:** Política de tags obligatorios (mostrar JSON)
6. IAM → Users → ver usuario del lab (o LabRole)
7. 📸 **SCREENSHOT 15:** Resumen del LabRole/LabInstanceProfile con permisos

---

### SECCIÓN 1.3 — Tagging

1. Consola AWS → EC2 → Instances
2. Clic en una instancia → pestaña "Tags"
3. 📸 **SCREENSHOT 16:** Tags de la instancia EC2 (Project, Environment, Owner, CostCenter, ManagedBy)
4. RDS → Databases → clic en la DB → pestaña "Tags"
5. 📸 **SCREENSHOT 17:** Tags del RDS
6. EC2 → ALB → clic en el ALB → pestaña "Tags"
7. 📸 **SCREENSHOT 18:** Tags del ALB

---

### SECCIÓN 1.4 — Well-Architected Framework

1. Consola AWS → buscar "Well-Architected Tool"
2. Clic en "Define workload"
3. Configurar:
   - Name: "TechNova-ecommerce"
   - Description: "Plataforma e-commerce TechNova en AWS"
   - Review owner: tu nombre
   - Environment: Production
   - Regions: us-east-1
   - Account IDs: (dejar vacío)
4. 📸 **SCREENSHOT 19:** Formulario de creación del workload completado
5. Clic en "Define workload" → luego "Start reviewing"
6. Responder las preguntas de cada pilar (seleccionar las que aplican a tu setup)
7. 📸 **SCREENSHOT 20:** Respondiendo las preguntas del pilar "Cost Optimization"
8. 📸 **SCREENSHOT 21:** Respondiendo las preguntas del pilar "Security"
9. Al terminar → ver el resumen de riesgos (HRI/MRI)
10. 📸 **SCREENSHOT 22:** Dashboard de WAF con resumen de los 5 pilares y riesgos identificados
11. Clic en "Generate report" o ver cada pilar
12. 📸 **SCREENSHOT 23:** Lista de HRI (High Risk Items) identificados

---

### SECCIÓN 1.5 — Optimización (Pricing Calculator comparativo)

1. En AWS Pricing Calculator → crear segunda estimación
2. EC2: t3.small, 1 año Reserved (Partial Upfront)
3. 📸 **SCREENSHOT 24:** Comparativa On-Demand vs Reserved 1 año (tabla de ahorro)
4. EC2 → Instances → ver instancias en estado stopped o sin uso
5. 📸 **SCREENSHOT 25:** Lista de instancias (para identificar recursos potencialmente ociosos)
6. EC2 → Volumes → ver volúmenes EBS y su tipo (gp3 vs gp2)
7. 📸 **SCREENSHOT 26:** Lista de volúmenes EBS mostrando tipo gp3

---

### EXTRAS útiles para el informe

- 📸 **SCREENSHOT 27:** CloudWatch Dashboard con métricas de CPU, ALB y RDS
- 📸 **SCREENSHOT 28:** Auto Scaling Group → Activity tab (historial de escalado)
- 📸 **SCREENSHOT 29:** RDS → ver que Multi-AZ está habilitado
- 📸 **SCREENSHOT 30:** S3 → bucket de CloudTrail con logs generados

---

## PASO 5 — Destruir al terminar (ahorra créditos)

```bash
terraform destroy -auto-approve
```

O en GitHub: Actions → terraform-destroy → Run workflow → escribir "yes"
