# Nixos-Ivalice
Keio's personal NixOS configuration for his host system: Ivalice.

## Install
On a fresh NixOS system, run:

```bash
curl -fsSL https://raw.githubusercontent.com/Keiyoko/nixos-ivalice/main/install.sh | bash
```
After installing, don't forget to change your wallpaper in DMS settings to trigger matugen theming.

## Features

**Desktop**
- [Niri](https://github.com/YaLTeR/niri) (Wayland compositor)
- [DankMaterialShell](https://github.com/danklinux/DankMaterialShell) with dynamic matugen theming
- Nautilus (Default GNOME File Manager)
- [Zen Browser](https://github.com/youwen5/zen-browser-flake) (NixOS flake)
- Bitwarden (Password Manager)

**Terminal & Shell**
- Alacritty with DMS theming
- [Eza](https://github.com/eza-community/eza) with icon aliases
- Fastfetch + [Areofyl](https://github.com/areofyl/fetch) animated fetch on terminal open

**Apps**
- [Materialgram](https://github.com/kukuruzka165/materialgram) (Fork of telegram)
- [Equibop](https://github.com/Equicord/Equibop) (Fork of vesktop)
- Spotify with Remote Support

**Gaming**
- Steam with Remote Play, Dedicated Server, and Local Network Transfer support
- [Gamescope](https://github.com/ValveSoftware/gamescope)
- [Gamemode](https://github.com/FeralInteractive/gamemode) optimizations
- [Oversteer](https://github.com/berarma/oversteer) (Steering wheel support for Logitech)

**System**
- Automatic Nix store optimization
- Garbage collection every 3 days
- Home Manager for declarative dotfile management
- Flakes enabled

## Notes
- This install script **DOES NOT INCLUDE** graphical drivers as I am on an AMD system. You have to provide your own drivers if you use an NVIDIA system.
- This install script includes auto-mounts for my personal drives, remove this as needed or edit them as needed.
