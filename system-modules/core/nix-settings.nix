{ ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Whitelist Electron needed by Equibop
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];

  # Automatic Store Optimization
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    persistent = true;
    options = "--delete-older-than 7d";
  };
}
