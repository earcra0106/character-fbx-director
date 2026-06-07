#!/bin/bash
set -eu

mkdir -p "${HOME}/.codex"
mkdir -p "${HOME}/.config/gh"
mkdir -p "${HOME}/.ssh"

[ -f "${HOME}/.ssh/config" ]      || touch "${HOME}/.ssh/config"
[ -f "${HOME}/.ssh/known_hosts" ] || touch "${HOME}/.ssh/known_hosts"
[ -f "${HOME}/.gitconfig" ]       || touch "${HOME}/.gitconfig"

if [ -n "$SSH_AUTH_SOCK" ] && [ -S "$SSH_AUTH_SOCK" ]; then
    echo "SSH_AUTH_SOCK is valid: $SSH_AUTH_SOCK"
else
    # SSH_AUTH_SOCKがディレクトリとして作成されている場合はエラーを出す
    if [ -d "$SSH_AUTH_SOCK" ]; then
        echo "Error: SSH_AUTH_SOCK is a directory: $SSH_AUTH_SOCK"
        exit 1
    fi

    # SSH_AUTH_SOCKが未定義の場合は、適当なダミーパスを割り当てる
    TARGET_SOCK="${SSH_AUTH_SOCK:-/tmp/dummy_ssh_auth.sock}"

    if [ ! -e "$TARGET_SOCK" ]; then
        echo "Creating dummy file for SSH_AUTH_SOCK at $TARGET_SOCK"
        touch "$TARGET_SOCK"
    fi
fi
