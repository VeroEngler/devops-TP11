# ==============================================================================
# providers.tf — Configuración de proveedores y backend
# TP11B — Operaciones 1
# ==============================================================================
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }

  # En este ejercicio académico almacenamos el estado en el backend local del host
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}
