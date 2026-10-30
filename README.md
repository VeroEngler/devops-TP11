# TP11 — Infraestructura como Código con Terraform

## Recursos creados

| Recurso | Tipo | Módulo |
|---|---|---|
| Red app (`*-app-dev`) | `docker_network` | network |
| Red monitoring (`*-monitoring-dev`) | `docker_network` | network |
| Volumen Postgres | `docker_volume` | storage |
| Volumen Grafana | `docker_volume` | storage |
| Volumen Prometheus | `docker_volume` | storage |
| Contenedor Postgres | `docker_container` | app |
| Contenedor Backend (×N) | `docker_container` | app |
| Contenedor Frontend | `docker_container` | app |

## Uso

Ejecutar en bash
# Copiar y editar variables
cp terraform.tfvars.example terraform.tfvars

# Ciclo completo
terraform init
terraform validate
terraform plan
terraform apply

# Ver outputs
terraform output

# Destruir
terraform destroy
Multi-entorno
# Desarrollo (defaults)
terraform apply

# Producción
terraform apply -var-file=envs/prod/terraform.tfvars
Estructura de módulos
modules/
├── network/   → redes Docker con subnets dedicadas
├── storage/   → volúmenes persistentes con labels
└── app/       → contenedores con healthchecks y dependencias
