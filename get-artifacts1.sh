#!/bin/bash

TOKEN=$(cat ~/token.gh)
USERNAME="lroyer0"
REPO="graphes"

# Récupérer la liste des artifacts
curl -s \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/${USERNAME}/${REPO}/actions/artifacts > gh-artifacts.json

echo "Liste des artifacts récupérée"

# Installer jq si nécessaire
if ! command -v jq &> /dev/null; then
    echo "Installation de jq..."
    sudo apt-get install -y jq
fi

# Extraire l'ID du dernier artifact (le plus récent)
ARTIFACT_ID=$(jq '.artifacts[0].id' gh-artifacts.json)

echo "ID de l'artifact : $ARTIFACT_ID"

# Télécharger l'artifact
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  --output artifact.zip \
  https://api.github.com/repos/${USERNAME}/${REPO}/actions/artifacts/${ARTIFACT_ID}/zip

echo "Artifact téléchargé"

# Dézipper
unzip -o artifact.zip

echo "Extraction terminée"
ls -lh *.svg
