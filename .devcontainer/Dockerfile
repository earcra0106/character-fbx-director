ARG NODE_IMAGE=node:24.16.0-slim
ARG BASE_IMAGE=python:3.12.13-slim-bookworm
ARG UV_IMAGE=ghcr.io/astral-sh/uv:0.11.19

FROM ${UV_IMAGE} AS uv_bin

FROM ${NODE_IMAGE} AS node_bin

FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

SHELL [ "/bin/bash", "-c" ]

COPY --from=node_bin /usr/local/lib/node_modules/npm /usr/local/lib/node_modules/npm
COPY --from=node_bin /usr/local/bin/node /usr/local/bin/node
COPY --from=uv_bin /uv /uvx /bin/

RUN ln -s /usr/local/bin/node /usr/local/bin/nodejs && \
    ln -s ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm && \
    ln -s ../lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx

ARG PNPM_VERSION

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        sudo \
        bubblewrap \
        ca-certificates \
        openssh-client \
        openssl \
        curl \
        git \
        jq \
        ripgrep \
        sed \
        gawk \
        vim && \
    groupadd --gid 1000 dev && \
    useradd --uid 1000 --gid dev --shell /bin/bash --create-home dev && \
    npm install -g \
        pnpm@${PNPM_VERSION} \
        @openai/codex && \
    mkdir -p /workspace && chown -R dev:dev /workspace && \
    mkdir -p /workspace/worker/.venv && chown -R dev:dev /workspace/worker/.venv && \
    mkdir -p /home/dev/.local/share/pnpm/store && chown -R dev:dev /home/dev/.local && \
    mkdir -p /home/dev/.codex && chown -R dev:dev /home/dev/.codex && \
    mkdir -p /home/dev/.ssh && chown -R dev:dev /home/dev/.ssh && \
    mkdir -p /home/dev/.config/gh && chown -R dev:dev /home/dev/.config && \
    echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN test "$(python --version)" = "Python 3.12.13" && \
    test "$(python3 --version)" = "Python 3.12.13"

ENV TZ=Asia/Tokyo

WORKDIR /workspace

USER dev
RUN pnpm config set store-dir "/home/dev/.local/share/pnpm/store"
