{config, pkgs, inputs, username, ... }:
{
 ################# System Version #################

 system.stateVersion = "26.05";

 ################ Imports #################

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

################ Drive Mounts (Change these out if needed) ################# 

 # Drive 1 Mount
 fileSystems."/mnt/Marche" = {
   device = "/dev/disk/by-uuid/1720a584-66b6-4fa3-beca-1c977ba37f1f";
   fsType = "ext4";
   options = [
     "defaults"
     "nofail"
     "x-gvfs-show"
   ];
 };

 # Drive 2 Mount
 fileSystems."/mnt/Ritz" = {
   device = "/dev/disk/by-uuid/40170e14-94ff-44f5-a5c7-5fda8af305c5";
   fsType = "ext4";
   options = [
     "defaults"
     "nofail"
     "x-gvfs-show"
   ];
 };

 ################# Display Configuration ##############

 # Window Manager
 programs.niri.enable = true;

 # DMS Shell Configuration
 programs.dms-shell = {
  enable = true;
  systemd = {
    enable = true;
    restartIfChanged = true;
 };

  enableSystemMonitoring = true;
  enableDynamicTheming = true;
 };

 # Font Packages
 fonts.packages = with pkgs; [
   nerd-fonts.fira-code
   nerd-fonts.jetbrains-mono
   nerd-fonts.symbols-only
   nerd-fonts.iosevka
 ];

 ################ Bootloader ##############

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Disable Watchdog in Kernel
  boot.kernelParams = [ "nowatchdog" ];

 ########## System Definitions ############

  networking.hostName = "Ivalice"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Singapore";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_SG.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_SG.UTF-8";
    LC_MEASUREMENT = "en_SG.UTF-8";
    LC_MONETARY = "fil_PH";
    LC_NAME = "en_SG.UTF-8";
    LC_NUMERIC = "en_SG.UTF-8";
    LC_PAPER = "en_SG.UTF-8";
    LC_TELEPHONE = "fil_PH";
    LC_TIME = "en_SG.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable GVFS for Nautilus
  services.gvfs.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "networkmanager" "wheel" ];
  };

 ############ Unfree Packages and Experimental Features ##############

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

 ############# Packages ####################

  environment.systemPackages = with pkgs; [
  
  # Zen Browser Flake
  (inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default)

  # System Critical Packages
  vim-full
  eza
  git
  alacritty
  nautilus
  bitwarden-desktop
  xwayland-satellite
  wl-clipboard

  # Animated Fetch
  fastfetch
  (stdenv.mkDerivation {
  pname = "areofyl-fetch";
  version = "unstable";
  src = inputs.areofyl-fetch;
  nativeBuildInputs = [ gcc ];
  buildPhase = ''
    sed -i 's/#define ANIM_WIDTH 60/#define ANIM_WIDTH 45/' fetch.c
    sed -i 's/#define GAP 2/#define GAP 1/' fetch.c
    cc -O2 -o fetch fetch.c -lm
  '';
  installPhase = "install -Dm755 fetch $out/bin/fetch";
  })

  # Audio Packages
  qpwgraph
  pavucontrol

  # Icon Packages
  quintom-cursor-theme

  # Other Packages
  equibop
  materialgram
  spotify

  # Hardware Packages
  oversteer
  ];
 
 ############# Configurations #############

  # Steam Configuration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  
  # Game Optimizations
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

 
  # Whitelist Electron needed by Equibop
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];
 
 ######### Display Manager ###########
 
  # DMS Greeter
  services.displayManager.dms-greeter = {
   enable = true;
   compositor = {name = "niri"; };
   configHome = "/home/${username}";
   configFiles = ["/home/${username}/.config/DankMaterialShell/settings.json"];
  };

 ######### System Configurations ###########

  # Eza Aliases
  environment.shellAliases = {
     ls = "eza --icons";
     ll = "eza -l --icons";
     la = "eza -a --icons";
     lla = "eza -la --icons";
  };

  # Screenshare Portals
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Animated Fetch on Terminal Open
  programs.bash.interactiveShellInit = ''fetch'';

  # Automatic Store Optimization
  nix.settings.auto-optimise-store = true;
  nix.gc = {
  automatic = true;
  dates = "weekly";
  persistent = true;
  options = "--delete-older-than 7d";
  };

 ########### Hardware Configurations ############
 
 # Logitech Steering Wheel Drivers
 hardware.new-lg4ff.enable = true;
 services.udev.packages = with pkgs; [
   oversteer
  ];

 ########### Networking Configuration ###########

 # Preserve SSH_AUTH_SOCK in sudo
 security.sudo.extraConfig = ''
   Defaults env_keep+=SSH_AUTH_SOCK
 '';

 # Enable Spotify Connect
 networking.firewall.allowedTCPPorts = [ 57621 ];
 networking.firewall.allowedUDPPorts = [ 5353 ];
}
