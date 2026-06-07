#!/bin/bash
set -eu

# SSHソケット
if [ -S /host_config/ssh_auth.sock ]; then
  mkdir -p ~/.ssh
  ln -sf /host_config/ssh_auth.sock ~/.ssh/ssh_auth.sock
fi

# 対話シェルのプロンプト設定
cat <<'EOF' >> ~/.bashrc

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;35m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$ '
alias ll='ls -la'

echo -e "\n\e[1;37mWelcome to the DevContainer!\e[0m\n"

EOF
