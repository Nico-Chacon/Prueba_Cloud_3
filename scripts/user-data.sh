#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -x

# Instalar Docker
yum update -y
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user
usermod -a -G docker ssm-user

# Instalar Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Crear directorio de la aplicación
mkdir -p /home/ec2-user/app/html
cd /home/ec2-user/app

# Docker Compose
cat > docker-compose.yml << 'DOCKEREOF'
version: '3'
services:
  nginx:
    image: nginx:alpine
    container_name: technova-nginx
    ports:
      - "80:80"
    restart: always
    volumes:
      - ./html:/usr/share/nginx/html
DOCKEREOF

# Página web TechNova
cat > html/index.html << 'HTMLEOF'
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechNova Solutions</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            background: white;
            padding: 50px 60px;
            border-radius: 20px;
            text-align: center;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            max-width: 600px;
        }
        h1 { color: #2c3e50; font-size: 2.5em; margin-bottom: 10px; }
        h2 { color: #764ba2; font-size: 1.3em; margin-bottom: 30px; font-weight: normal; }
        .badge {
            display: inline-block;
            background: #27ae60;
            color: white;
            padding: 8px 20px;
            border-radius: 50px;
            font-weight: bold;
            margin: 8px 5px;
            font-size: 0.9em;
        }
        .badge.blue { background: #2980b9; }
        .badge.orange { background: #e67e22; }
        .info { margin-top: 30px; color: #7f8c8d; font-size: 0.85em; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 TechNova Solutions</h1>
        <h2>Alta Disponibilidad en AWS — ARY1101</h2>
        <div>
            <span class="badge">✅ Auto Scaling Group</span>
            <span class="badge blue">✅ ALB Activo</span>
            <span class="badge orange">✅ Multi-AZ RDS</span>
        </div>
        <div class="info">
            <p>Estudiante: Chacon | DuocUC 2025</p>
            <p>Infraestructura desplegada con Terraform IaC</p>
        </div>
    </div>
</body>
</html>
HTMLEOF

# Permisos correctos
chown -R ec2-user:ec2-user /home/ec2-user/app

# Iniciar contenedor
/usr/local/bin/docker-compose up -d

echo "TechNova user-data setup completed successfully"
