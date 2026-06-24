#!/usr/bin/env bash
set -e

REPO="https://github.com/Keiyoko/nixos-ivalice"

# Print a clear recovery message if anything fails mid-install
trap 'echo ""; echo "ERROR: Installation failed. Your hardware config is at /tmp/hardware-configuration.nix"; echo "To recover: sudo mkdir -p /etc/nixos && sudo cp /tmp/hardware-configuration.nix /etc/nixos/"' ERR

if [ ! -f /etc/nixos/hardware-configuration.nix ]; then
  echo "ERROR: /etc/nixos/hardware-configuration.nix not found. Are you on an installed NixOS system?"
  exit 1
fi

echo "==> Backing up hardware configuration..."
sudo cp /etc/nixos/hardware-configuration.nix /tmp/hardware-configuration.nix

echo "==> Clearing /etc/nixos..."
sudo rm -rf /etc/nixos

echo "==> Cloning nixos-ivalice..."
nix-shell -p git --run "sudo git clone $REPO /etc/nixos" || {
  echo "ERROR: Clone failed. Restoring hardware config..."
  sudo mkdir -p /etc/nixos
  sudo cp /tmp/hardware-configuration.nix /etc/nixos/
  exit 1
}

echo "==> Verifying clone..."
for f in flake.nix configuration.nix home.nix; do
  [ -f "/etc/nixos/$f" ] || { echo "ERROR: Expected /etc/nixos/$f not found after clone."; exit 1; }
done

echo "==> Restoring hardware configuration..."
sudo cp /tmp/hardware-configuration.nix /etc/nixos/hardware-configuration.nix

echo "==> Rebuilding system..."
sudo nixos-rebuild switch --flake /etc/nixos#Ivalice

echo "==> Cleaning up..."
# $0 is 'bash' when piped via curl, so only remove if it's an actual file path
if [ -f "$0" ] && [ "$0" != "bash" ]; then
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
  sudo rm -- "$0"
  [ -f "$SCRIPT_DIR/README.md" ] && sudo rm -f -- "$SCRIPT_DIR/README.md"
fi

echo ""
echo "Done! Remember to update drive UUIDs in configuration.nix after booting."
echo "After boot, 'dms setup' should run automatically."
echo ""
read -p "Reboot now? [y/N] " confirm
if [[ "$confirm" == [yY] ]]; then
  echo "Rebooting in:"
  for i in 5 4 3 2 1; do
    echo "  $i..."
    sleep 1
  done
  sudo reboot
fi
