ARG BASE_IMAGE=node:24.16.0-slim
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

SHELL [ "/bin/bash", "-c" ]

ENV PNPM_HOME=/home/node/.local/share/pnpm
ENV PATH="${PNPM_HOME}:${PATH}"

ARG PNPM_VERSION

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        openssl && \
    mkdir -p /home/node/.local/share/pnpm/store && \
    npm install -g pnpm@${PNPM_VERSION} && \
    chown -R node:node /home/node/.local && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV TZ=Asia/Tokyo

WORKDIR /workspace/apps

USER node
RUN pnpm config set store-dir "/home/node/.local/share/pnpm/store"
