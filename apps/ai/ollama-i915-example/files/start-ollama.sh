#!/bin/bash

# Prepare the IPEX-LLM Ollama runtime: `init-ollama` symlinks the bundled
# binary and libraries into the working directory.
mkdir -p /llm/ollama
cd /llm/ollama
init-ollama

# Expose the IPEX ollama binary at /bin/ollama so the chart's built-in
# lifecycle postStart hook can pull models using the standard path.
cat > /bin/ollama <<'EOF'
#!/bin/bash
cd /llm/ollama
exec ./ollama "$@"
EOF
chmod +x /bin/ollama
exec ./ollama serve

exec ./ollama serve
