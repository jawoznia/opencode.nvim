FROM archlinux:latest

# --- Base tools ---
RUN pacman -Sy --noconfirm \
  git \
  base-devel \
  nodejs \
  npm \
  curl \
  neovim \
  ripgrep \
  fd \
  just \
  busted \
  ca-certificates \
  lua \
  && pacman -Scc --noconfirm

# --- Install OpenCode ---
RUN curl -fsSL https://opencode.ai/install | bash

ENV PATH="/root/.opencode/bin:${PATH}"

# --- OpenCode default config directory ---
RUN mkdir -p /etc/opencode

# --- Default OpenCode config (Ollama on host) ---
RUN cat <<'EOF' > /etc/opencode/opencode.json
{
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "options": {
        "baseURL": "http://host.containers.internal:11434/v1"
      },
      "models": {
        "Qwen2.5-Coder:7b": { "name": "Qwen2.5-Coder:7b" },
      }
    }
  },
  "model": "Qwen2.5-Coder:7b"
}
EOF

# --- Tell OpenCode to use system config by default ---
ENV OPENCODE_CONFIG=/etc/opencode/opencode.json

WORKDIR /workspace
