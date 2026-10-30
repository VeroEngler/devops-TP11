#!/bin/bash
# ==============================================================================
# simular-drift.sh — Inyección de Deriva de Infraestructura (TP11B)
# ==============================================================================
set -euo pipefail

echo -e "\033[1;31m=== SIMULANDO ALTERACIÓN ILEGAL FUERA DE TERRAFORM ===\033[0m"

# 1. Buscar un contenedor administrado por Terraform y detenerlo/borrarlo a mano
TARGET_CONTAINER=$(docker ps --filter "label=managed-by=terraform" --format "{{.Names}}" | grep backend | head -n1 || true)

if [ -n "$TARGET_CONTAINER" ]; then
    echo "Secuestrando y eliminando manualmente el contenedor: $TARGET_CONTAINER"
    docker stop "$TARGET_CONTAINER" >/dev/null
    docker rm "$TARGET_CONTAINER" >/dev/null
    echo "Contenedor eliminado directamente vía Docker CLI."
else
    echo "No se encontraron contenedores activos de backend. Modificando una red..."
    docker network disconnect devops-portfolio-app-prod notes-db-prod 2>/dev/null || true
fi

echo ""
echo -e "\033[1;33m¡Deriva inyectada exitosamente!\033[0m"
echo "El servidor real ahora difiere del estado guardado en Terraform."
echo "Prueba ejecutar: terraform plan -var-file=envs/prod/terraform.tfvars"
echo "Observa cómo Terraform detecta que el recurso falta y propone recrearlo (+)."
