#!/bin/bash
set -euo pipefail

TOTAL=0
PASSED=0

ok()   { echo -e "  \033[0;32m[PASS]\033[0m $1"; PASSED=$((PASSED+1)); }
fail() { echo -e "  \033[0;31m[FAIL]\033[0m $1"; }
info() { echo -e "\n\033[1;34m=== $1 ===\033[0m"; }
eval_check() { TOTAL=$((TOTAL+1)); }

echo -e "\033[1;36m"
echo "  =============================================================="
echo "    AUDITORÍA DE TERRAFORM EN CI/CD Y GITOPS (TP11B)"
echo "  =============================================================="
echo -e "\033[0m"

info "1. Verificación de Manifiestos de GitHub Actions"
for wf in terraform-pr.yml terraform-cd.yml terraform-drift.yml; do
    eval_check
    if [ -f ".github/workflows/$wf" ]; then
        ok "Workflow presente: .github/workflows/$wf"
    else
        fail "Falta el workflow: .github/workflows/$wf"
    fi
done

info "2. Formato y Calidad de Código HCL"
eval_check
if terraform fmt -check -recursive >/dev/null 2>&1; then
    ok "Todos los archivos .tf cumplen estrictamente el formato oficial (terraform fmt)"
else
    fail "Hay archivos desalineados. Ejecuta: terraform fmt -recursive"
fi

eval_check
if terraform validate >/dev/null 2>&1; then
    ok "Validación sintáctica y de dependencias correcta (terraform validate)"
else
    fail "Errores de validación en la configuración HCL"
fi

info "3. Prueba de Detección de Deriva (Drift Engine)"
eval_check
set +e
terraform plan -detailed-exitcode -var-file=envs/prod/terraform.tfvars -no-color >/dev/null 2>&1
CODE=$?
set -e

if [ "$CODE" -eq 0 ]; then
    ok "Infraestructura en sincronía total (Exit Code 0: 0 desvíos)"
elif [ "$CODE" -eq 2 ]; then
    ok "Motor de Drift operativo: detectó discrepancias reales en el host (Exit Code 2)"
else
    fail "Error en la ejecución de terraform plan (Exit Code: $CODE)"
fi

echo -e "\n\033[1;35m==============================================================\033[0m"
echo -e " Resultado: \033[1;32m$PASSED de $TOTAL pruebas superadas\033[0m"
if [ "$PASSED" -eq "$TOTAL" ]; then
    echo -e " Estado: \033[1;32m¡APROBADO CON ÉXITO!\033[0m Pipeline GitOps 100% operativo."
else
    echo -e " Estado: \033[1;31mREQUIERE AJUSTES\033[0m"
fi
echo ""
