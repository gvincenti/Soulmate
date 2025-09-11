#!/bin/bash

USER="gvincenti"
TOKEN=$(cat token.txt)

if [ -z "$1" ]; then
  echo "⚠️ Uso: ./gitpush.sh <repo> \"<mensaje>\""
  exit 1
fi

REPO="$1"
mensaje="$2"

if [ -z "$mensaje" ]; then
  echo "⚠️ No pasaste mensaje de commit."
  exit 1
fi

URL="https://$USER:$TOKEN@github.com/$USER/$REPO.git"

git add .
git commit -m "$mensaje"
git push "$URL" main

