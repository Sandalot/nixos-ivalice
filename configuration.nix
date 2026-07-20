{ config, pkgs, inputs, username, ... }:
{
  # System Version
  system.stateVersion = "26.05";

  ################ Imports #################
  imports = [

    # System Modules
    ./system-modules/hardware-configuration.nix
    ./system-modules/desktop.nix
    ./system-modules/dms-greeter.nix
    ./system-modules/gaming.nix
    ./system-modules/hardware.nix

    # Core Modules
    ./system-modules/core/boot.nix
    ./system-modules/core/locale.nix
    ./system-modules/core/users.nix
    ./system-modules/core/nix-settings.nix

    ./system-modules/packages.nix
    ./system-modules/shell.nix
    ./system-modules/networking.nix

    # Service Modules
    ./service-modules/syncthing.nix
    ./service-modules/orca-slicer.nix
  ];

  ############### Modules ################
  modules.desktop.enable = true;
  modules.dms-greeter.enable = true;
  modules.gaming.enable = true;
  modules.hardware.enable = true;
}
