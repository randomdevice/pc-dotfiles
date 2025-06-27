When initializing the following services, ensure that podman has the following secrets set:

podman create secret POSTGRES_PASSWORD POSTGRES_PASSWORD.txt
podman create secret POSTGRES_USER POSTGRES_USER.txt

Where POSTGRES_PASSWORD.txt contains a password used for all postrges databases.
Where POSTGRES_USER.txt contains a username used for all postgres databases.

The `launch_script.bash` file is used for debugging. It tests container pulls and showcases a configuration to generate systemd files from.

The `install_services.bash` file installs generated services in the `services` folder to a users local systemd folder.

Ensure `mkdir -p $HOME/.config/systemd` exists.
