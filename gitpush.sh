#!/bin/bash

# --------------------------
# Configuración
# --------------------------
USER="gvincenti"

# Revisar que exista token.txt
if [ ! -f token.txt ]; then
    echo "❌ No se encontró token.txt. Crealo con tu token de GitHub."
    exit 1
fi

TOKEN=$(cat token.txt)

# --------------------------
# Verificar si estamos en un repo Git
# --------------------------
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ No estás en un repositorio Git."
    exit 1
fi

# --------------------------
# Mensaje de commit
# --------------------------
if [ -z "$1" ]; then
    echo "Escribí el mensaje de commit:"
    read mensaje
else
    mensaje="$1"
fi

# --------------------------
# Detectar rama actual
# --------------------------
BRANCH=$(git rev-parse --abbrev-ref HEAD)

# --------------------------
# Detectar remoto origin
# --------------------------
REMOTE=$(git remote get-url origin)

# --------------------------
# Verificar si hay cambios
# --------------------------
if git diff-index --quiet HEAD --; then
    echo "⚠️ No hay cambios para commitear."
    exit 0
fi

# --------------------------
# Crear carpeta de logs si no existe
# --------------------------
LOG_DIR="git_logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/$(date +%Y-%m-%d).log"

# --------------------------
# Obtener lista de archivos modificados
# --------------------------
CHANGES=$(git status --short)

# --------------------------
# Guardar commit en logs
# --------------------------
{
    echo "----------------------------------------"
    echo "📅 $(date '+%Y-%m-%d %H:%M:%S')"
    echo "🌿 Rama: $BRANCH"
    echo "📝 Commit: $mensaje"
    echo "📂 Cambios:"
    echo "$CHANGES"
    echo
} >> "$LOG_FILE"

# --------------------------
# Configurar credenciales temporales
# --------------------------
git config credential.helper store
printf "protocol=https\nhost=github.com\nusername=$USER\npassword=$TOKEN\n" | git credential approve

# --------------------------
# Ejecutar git
# --------------------------
git add .
git commit -m "$mensaje"
git push "$REMOTE" "$BRANCH"

# --------------------------
# Limpiar credenciales de memoria
# --------------------------
printf "protocol=https\nhost=github.com\nusername=$USER\npassword=$TOKEN\n" | git credential reject
git config --unset credential.helper

echo "✅ Push completado y log guardado en $LOG_FILE"
