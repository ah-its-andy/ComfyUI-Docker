#!/bin/bash

set -euo pipefail

gcs() {
    git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules "$@"
}

echo "########################################"
echo "[INFO] Downloading ComfyUI & Essential Nodes for API mode..."
echo "########################################"

cd /default-comfyui-bundle
git clone 'https://github.com/comfyanonymous/ComfyUI.git'
cd /default-comfyui-bundle/ComfyUI
# Using stable version (has a release tag)
git reset --hard "$(git tag | grep -e '^v' | sort -V | tail -1)"

cd /default-comfyui-bundle/ComfyUI/custom_nodes
gcs https://github.com/Comfy-Org/ComfyUI-Manager.git

# Force ComfyUI-Manager to use PIP instead of UV
mkdir -p /default-comfyui-bundle/ComfyUI/user/default/ComfyUI-Manager

cat <<EOF > /default-comfyui-bundle/ComfyUI/user/default/ComfyUI-Manager/config.ini
[default]
use_uv = False
EOF

# Workspace
gcs https://github.com/crystian/ComfyUI-Crystools.git

# General - Essential for workflow management
gcs https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git

echo "########################################"
echo "[INFO] Skipping model downloads for API-only mode..."
echo "########################################"
