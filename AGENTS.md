# Agent Instructions: Arma 3 Server Docker Project

Welcome to the `arma3server-docker` project. This repository provides a Docker-based environment for running Arma 3 servers using [LinuxGSM](https://linuxgsm.com/).

## Project Overview

The project is structured to support multiple server instances (e.g., `base`, `experimental`, `main`, `spider`) using a common `Dockerfile` but different configuration sets and modlists.

### Key Technologies
- **Docker & Docker Compose**: Orchestration and containerization.
- **LinuxGSM**: Command-line tool for quick, simple deployment and management of various dedicated game servers.
- **SteamCMD**: Used by LinuxGSM to download Arma 3 and mods from the Steam Workshop.
- **Bash Scripts**: Custom automation for mod management and container entrypoint.

## Directory Structure

- `/arma3server-html/`: Contains HTML files exported from the Arma 3 Launcher, used to define modsets.
- `/config/`: Configuration templates for different server instances.
    - `/config/<instance>/`: Instance-specific configs (`arma3server.server.cfg`, `common.cfg`, `cba_settings.sqf`, etc.).
- `/scripts/`: Automation scripts for the container.
    - `entrypoint.sh`: Main container entrypoint handling initialization and server startup.
    - `create_sublist.sh`: Extracts Steam Workshop IDs from HTML modlists.
    - `set_modlist.sh`: Formats the modlist for LinuxGSM configuration.
- `/notes/`: Helpful documentation and snippets for developers.

## Core Workflows

### 1. Adding or Updating a Server Instance
To create a new server instance (e.g., `newserver`):
1. Create a directory `config/newserver/` and populate it with the required config files (copy from `config/base/` as a starting point).
2. Add a corresponding `docker-compose.newserver.yml` file.
3. Update the `SERVER_NAME` and `MODPACK_PATH` build arguments in the compose file.

### 2. Managing Mods
Mods are defined by HTML files in `arma3server-html/`.
- The `entrypoint.sh` script uses `create_sublist.sh` and `set_modlist.sh` to parse these HTML files during the first run.
- Workshop IDs are extracted and written to LinuxGSM's config.
- Mods are stored in a persistent volume (usually mapped to `/home/arma3server/mods` on the host).

### 3. Container Lifecycle
- **First Run**: The container detects the absence of a marker file, triggers `auto-install` via LinuxGSM, downloads mods, and sets up configurations.
- **Regular Start**: Subsequent starts skip installation and directly boot the Arma 3 server.
- **Shutdown**: The container traps `SIGTERM/SIGINT` to ensure the server stops gracefully via LinuxGSM. A `stop_grace_period` of 60s is configured in docker-compose to allow for a clean shutdown.

## Developer Guidelines

### Secrets Management
The project uses Docker secrets for Steam credentials:
- `steam_user`
- `steam_password`
- `steam_user_password` (combined for some legacy scripts)

Ensure these are present in the `./secrets/` directory (ignored by git) when running locally.

### Mod Naming
Arma 3 on Linux requires lowercase mod directories for consistency. The script `fix_mods_lowercase.sh` is available to help with this, though it is currently commented out in `entrypoint.sh`.

### Troubleshooting
- Logs are located at `/home/arma3server/log/` inside the container.
- The entrypoint tails these logs to `stdout` for visibility via `docker logs`.
- Use `docker exec -it <container_name> bash` to inspect the server state or run LinuxGSM commands manually (e.g., `./arma3server details`).

## Future Tasks (TODOs)
- Implement a Git-based synchronization for `userconfig`.
- Improve virtual mod mounting.
- Enhance profile management.
