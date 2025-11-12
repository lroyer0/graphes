#!/bin/bash

TOKEN=$(cat ~/token.gh)
USERNAME="lroyer0"
REPO="graphes"

# Récupérer la liste des artifacts si elle n'existe pas
if [ ! -f gh-artifacts.json ]; then
  echo "Récupération de la liste des artifacts..."
  curl -s \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/repos/${USERNAME}/${REPO}/actions/artifacts > gh-artifacts.json
fi

# Extraire les IDs dans un fichier
jq '.artifacts[].id' gh-artifacts.json > liste-id.txt

echo "=== Liste des IDs ==="
cat liste-id.txt

# Créer un dossier pour les artifacts
mkdir -p artifacts_telecharges

# Télécharger chaque artifact
while read -r ARTIFACT_ID; do
  
  # Récupérer le nom de l'artifact
  ARTIFACT_NAME=$(jq -r ".artifacts[] | select(.id == $ARTIFACT_ID) | .name" gh-artifacts.json)
  
  echo ""
  echo "Téléchargement de : $ARTIFACT_NAME (ID: $ARTIFACT_ID)"
  
  # Télécharger
  curl -L -s \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    --output "artifacts_telecharges/${ARTIFACT_NAME}.zip" \
    "https://api.github.com/repos/${USERNAME}/${REPO}/actions/artifacts/${ARTIFACT_ID}/zip"
  
  # Créer un sous-dossier et dézipper
  mkdir -p "artifacts_telecharges/${ARTIFACT_NAME}"
  unzip -q "artifacts_telecharges/${ARTIFACT_NAME}.zip" -d "artifacts_telecharges/${ARTIFACT_NAME}"
  
  echo "✓ Téléchargé dans artifacts_telecharges/${ARTIFACT_NAME}/"
  
done < liste-id.txt

echo ""
echo "=== Téléchargement terminé ==="
echo "Les artifacts sont dans : artifacts_telecharges/"
ls -R artifacts_telecharges/
