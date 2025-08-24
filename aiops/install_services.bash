systemctl stop --user openweb-ui
systemctl stop --user comfy-ui
systemctl stop --user qdrant
systemctl stop --user n8n
systemctl stop --user n8n-postgres
systemctl stop --user kokoro-speech.service

systemctl disable --user openweb-ui
systemctl disable --user comfy-ui
systemctl disable --user qdrant
systemctl disable --user n8n
systemctl disable --user n8n-postgres
systemctl disable --user kokoro-speech.service

cp -v services/*.service $HOME/.config/systemd/user/
systemctl --user daemon-reload

systemctl start --user ollama.service
systemctl start --user comfy-ui
systemctl start --user qdrant
#systemctl start --user n8n-postgres
#systemctl start --user n8n
systemctl start --user kokoro-speech.service
systemctl start --user openweb-ui

systemctl enable --user ollama.service
systemctl enable --user comfy-ui
systemctl enable --user qdrant
#systemctl enable --user n8n-postgres
#systemctl enable --user n8n
systemctl enable --user kokoro-speech.service
systemctl enable --user openweb-ui

