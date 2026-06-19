#!/bin/bash
set -e

# Prepare the IPEX-LLM Ollama runtime: `init-ollama` symlinks the bundled
# binary and libraries into the working directory.
mkdir -p /llm/ollama
cd /llm/ollama
init-ollama

# Start the Ollama server in the background, then pull the configured model
# (OLLAMA_MODEL env var, set in the Helm values). The pull is a no-op when
# the model is already present on the PVC.
./ollama serve &
serve_pid=$!

until OLLAMA_HOST=127.0.0.1:11434 ./ollama list >/dev/null 2>&1; do
  sleep 2
done

OLLAMA_HOST=127.0.0.1:11434 ./ollama pull "${OLLAMA_MODEL}" || true

wait "$serve_pid"
