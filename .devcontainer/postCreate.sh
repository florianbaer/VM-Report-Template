#!/usr/bin/env bash
set -euo pipefail

SSH_DIR="/home/vscode/.ssh"
if [ -d "${SSH_DIR}" ]; then
  sudo chmod 700 "${SSH_DIR}"
  sudo chmod -f 600 "${SSH_DIR}"/* 2>/dev/null || true
  sudo chown -R vscode:vscode "${SSH_DIR}"
fi

cd /workspaces/VM-Report-Template

if command -v pre-commit >/dev/null 2>&1; then
  echo "Installing pre-commit git hooks..."
  pre-commit install --install-hooks --overwrite
else
  echo "pre-commit executable not found; skipping hook installation" >&2
fi
