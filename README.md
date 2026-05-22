# S

Interactive SSH launcher from Ansible inventory. Pick a host with fuzzy search (fzf) or a numbered list, then drop straight into an SSH session.

## Requirements

- Python 3.6+
- [PyYAML](https://pypi.org/project/PyYAML/) — `pip install pyyaml`
- [fzf](https://github.com/junegunn/fzf) *(optional)* — falls back to a built-in numbered list picker

## Install

```bash
bash install.sh              # installs to ~/.local/bin/S
bash install.sh /usr/local/bin   # system-wide (may need sudo)
```

The script creates `~/.S/` for config and warns if the install directory is not in `$PATH`.

## Quick start

```bash
# 1. Point S at an inventory
S config --name prod --inventory ~/ansible/inventory/inventory.yml

# 2. Connect
S
```

## Configuration

Config is stored in `~/.S/config` (JSON). Manage it with:

```bash
# Add or update an environment
S config --name <name> --inventory <path>

# List all environments
S list env

# Use a specific environment for one session
S env <name>
S env <name> <query>
```

### Environment variable override

Set `S_ENV` to use a named environment without changing the stored default:

```bash
export S_ENV=staging
S          # uses the staging inventory
```

`S list env` marks both the stored default and the active `$S_ENV`.

## Usage

```
S [query]                                  SSH picker (default env)
S env <name> [query]                       SSH picker for a named env
S config --name <name> --inventory <path>  add/update an environment
S list env                                 list configured environments
S --help                                   show usage
```

### Picker

With **fzf** installed, hosts are shown in a fuzzy-search window. Without it, hosts are grouped and numbered — type a number, a hostname prefix, or a search term.

### Inventory format

Standard Ansible YAML inventory. Variables respected per host/group/all:

| Variable | Purpose |
|---|---|
| `ansible_host` | IP / hostname to connect to |
| `ansible_user` / `ansible_ssh_user` | SSH user (default: `root`) |
| `ansible_ssh_port` | SSH port (default: `22`) |
