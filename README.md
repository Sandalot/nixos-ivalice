# nixos-ivalice

Personal NixOS flake config for Ivalice.

## Setup

```bash
curl -fsSL https://raw.githubusercontent.com/Keiyoko/nixos-ivalice/main/install.sh | bash
```

> Drive mounts in `system-modules/hardware.nix` use personal UUIDs — update or remove before rebuilding (`lsblk -f` or `blkid`).

## Structure

```
etc/nixos/
├── flake.nix
├── flake.lock
├── configuration.nix
├── install.sh
│
├── certs/
│   └── caddy-local-ca.crt
│
├── system-modules/
│   ├── hardware-configuration.nix
│   ├── desktop.nix
│   ├── dms-greeter.nix
│   ├── gaming.nix
│   ├── hardware.nix
│   ├── packages.nix
│   ├── shell.nix
│   ├── networking.nix
│   └── core/
│       ├── boot.nix
│       ├── locale.nix
│       ├── users.nix
│       └── nix-settings.nix
│
├── service-modules/
│   ├── syncthing.nix
│   └── orca-slicer.nix
│
└── home-modules/
    ├── home.nix
    ├── compositor.nix
    ├── terminal.nix
    ├── neovim.nix
    ├── media.nix
    ├── browser.nix
    └── dank-shell.nix
```
