#!/bin/bash

# --------------------------
# Configuración
# --------------------------
USER="gvincenti"
TOKEN=$(cat token.txt)

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
REMOTE_URL=$(git remote get-url origin)

# Reemplazar https://github.com/ por https://USER:TOKEN@github.com/
URL=${REMOTE_URL/https:\/\/github.com\//https:\/\/$USER:$TOKEN@github.com\/}

# --------------------------
# Ejecutar git
# --------------------------
git add .
git commit -m "$mensaje"
git push "$URL" "$BRANCH"

