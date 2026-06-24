# Nixos-Ivalice
Keio's personal NixOS configuration for his host system: Ivalice.

## Install
On a fresh NixOS system, run:

```bash
curl -fsSL https://raw.githubusercontent.com/Keiyoko/nixos-ivalice/main/install.sh | bash
```
After installing, don't forget to change your wallpaper in DMS settings to trigger matugen theming
.
## Features

**Desktop**
- Niri (Wayland compositor)
- DankMaterialShell with dynamic matugen theming
- Nautilus (Default GNOME File Manager)
- Zen Browser
- Bitwarden (Password Manager)


**Terminal & Shell**
- Alacritty with DMS theming
- Eza with icon aliases
- Fastfetch + Areofyl animated fetch on terminal open

**Apps**
- [Materialgram](https://github.com/kukuruzka165/materialgram)
- [Equibop](https://github.com/Equicord/Equibop)
- Spotify with Remote Support
- Bitwarden (Password Manager)

**Gaming**
- Steam with Remote Play, Dedicated Server, and Local Network Transfer support
- Gamescope session
- Gamemode optimizations
- Oversteer (Steering wheel support for Logitech)


**System**
- Automatic Nix store optimization
- Garbage collection every 3 days
- Home Manager for declarative dotfile management
- Flakes enabled
