#!/bin/bash

#podman run -d --rm --device nvidia.com/gpu=all -v ollama:/root/.ollama -p 127.0.0.1:11434:11434 --name ollama docker.io/ollama/ollama

#podman run -d --rm \
#--name n8n-postgres \
#-p 5432:5432 \
#-v db_storage:/var/lib/postgresql/data \
#-e TZ="America/New_York" \
#--secret POSTGRES_PASSWORD,type=env,target=POSTGRES_PASSWORD \
#--secret POSTGRES_USER,type=env,target=POSTGRES_USER \
#postgres:latest

#podman run -d --rm \
# --name n8n \
# -p 5678:5678 \
# --network=pasta:-T,5432,-T,11434 \
# -e DB_TYPE=postgresdb \
# --add-host=postgres.local:127.0.0.1 \
# -e DB_POSTGRESDB_HOST=postgres.local \
# -e DB_POSTGRESDB_PORT=5432 \
# -e N8N_RUNNERS_ENABLED=true \
# -e TZ="America/New_York" \
# -e N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true \
# --secret POSTGRES_USER,type=env,target=DB_POSTGRESDB_DATABASE \
# --secret POSTGRES_USER,type=env,target=DB_POSTGRESDB_USER \
# --secret POSTGRES_PASSWORD,type=env,target=DB_POSTGRESDB_PASSWORD \
# -v n8n_data:/home/node/.n8n \
# docker.n8n.io/n8nio/n8n
#

#podman run -d --rm --device nvidia.com/gpu=all \
#  -p 127.0.0.1:9030:8000 \
#  --network=pasta:-T,3000 \
#  -v openedai-voices:/app/voice \
#  -v openedai-config:/app/config \
#  --name openedai-speech \
#  ghcr.io/matatonic/openedai-speech:latest

# podman run -d --rm --name kokoro-speech --device nvidia.com/gpu=all -p 127.0.0.1:9030:8880 ghcr.io/remsky/kokoro-fastapi-gpu
#

# podman generate systemd --new --files --name n8n-postgres
# podman generate systemd --new --files --name n8n
# podman generate systemd --new --files --name kokoro-speech
# podman generate systemd --new --files --name ollama
