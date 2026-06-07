ARG BASE_IMAGE=python:3.12.13-slim
ARG UV_VERSION=0.11.19

FROM ghcr.io/astral-sh/uv:${UV_VERSION} AS uv_bin

FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

SHELL [ "/bin/bash", "-c" ]

COPY --from=uv_bin /uv /uvx /bin/

RUN useradd -m dev

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        openssl && \
    mkdir -p /workspace/worker/.venv && chown -R dev:dev /workspace/worker/.venv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV TZ=Asia/Tokyo \
    UV_PROJECT_ENVIRONMENT=/workspace/worker/.venv \
    UV_COMPILE_BYTECODE=1

WORKDIR /workspace/worker

USER dev
