#!/bin/bash

TOKEN=$(cat ~/token.gh)

# Récupérer la liste des artifacts
curl \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/lroyer0/graphes/actions/artifacts > gh-artifacts.json

4472402040=$(cat gh-artifacts.json | grep -m 1 '"id"' | grep -o '[0-9]*')

curl \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  --output artifact.zip \
  https://api.github.com/repos/lroyer0/graphes/actions/artifacts/$ARTIFACT_ID/zip

# Dézipper
unzip artifact.zip
