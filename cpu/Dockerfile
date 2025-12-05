################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:cpu'
# A runtime environment for https://github.com/comfyanonymous/ComfyUI
# Using CPU only (not using GPU).
# The container will be running in root (easy for rootless deploy).
################################################################################

FROM ubuntu:24.04

LABEL maintainer="YAN Wenkun <code@yanwk.fun>"

RUN set -eu

################################################################################
# Python and essential tools

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-venv \
        python3-opencv \
        python3-pil \
        python3-wheel \
        python3-setuptools \
        git \
        curl \
        ca-certificates \
        ffmpeg \
        libgl1 \
        libglib2.0-0 \
        fonts-noto-core \
        fonts-noto-cjk \
        fonts-noto-color-emoji \
    && rm -rf /var/lib/apt/lists/* 

################################################################################
# Python packages for API mode with image processing

# Essential dependencies including image processing
COPY builder-scripts/.  /builder-scripts/

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        aiohttp \
        pillow \
        opencv-python-headless \
        numpy \
        requests \
        pyyaml \
        tqdm \
        safetensors \
        imageio \
        imageio-ffmpeg \
        tiktoken

################################################################################
# Pre-download ComfyUI

WORKDIR /default-comfyui-bundle

RUN bash /builder-scripts/preload-cache.sh

# Install ComfyUI-Openrouter_node
RUN cd /default-comfyui-bundle/ComfyUI/custom_nodes \
    && git clone https://github.com/gabe-init/ComfyUI-Openrouter_node.git

# Install only ComfyUI core requirements and OpenRouter node dependencies
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        -r '/default-comfyui-bundle/ComfyUI/requirements.txt' \
        -r '/default-comfyui-bundle/ComfyUI/custom_nodes/ComfyUI-Manager/requirements.txt' \
        -r '/default-comfyui-bundle/ComfyUI/custom_nodes/ComfyUI-Openrouter_node/requirements.txt'

################################################################################

RUN du -ah /root \
    && rm -rf /root/* \
    && rm -rf /root/.[^.]* /root/.??*

COPY runner-scripts/.  /runner-scripts/

USER root
VOLUME /root
WORKDIR /root
EXPOSE 8188
ENV CLI_ARGS="--listen 0.0.0.0"
CMD ["bash","/runner-scripts/entrypoint.sh"]
