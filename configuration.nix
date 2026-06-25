{ config, pkgs, inputs, username, ... }:
{
  ################# System Version #################

  system.stateVersion = "26.05";

  ################ Imports #################

  imports = [
    ./hardware-configuration.nix
    ./system-modules/desktop.nix
    ./system-modules/gaming.nix
    ./system-modules/hardware.nix
  ];

  ################ Bootloader #################

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "nowatchdog" ];

  ########## System Definitions #################

  networking.hostName = "Ivalice";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Singapore";

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

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  ############ Unfree Packages and Experimental Features #################

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  ############# Packages #################

  environment.systemPackages = with pkgs; [

    # Zen Browser Flake
    (inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default)

    # System Critical Packages
    neovim
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
  ];

  ############# Configurations #################

  # Fish Shell
  programs.fish.enable = true;

  # Whitelist Electron needed by Equibop
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];

  ######### System Configurations #################

  # Nvim config for root
  environment.etc."xdg/nvim/init.lua".text = ''
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.cursorline = true
    vim.opt.tabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.expandtab = true
  '';

  # Shell Aliases
  environment.shellAliases = {
    ls  = "eza --icons";
    ll  = "eza -l --icons";
    la  = "eza -a --icons";
    lla = "eza -la --icons";
  };

  # Automatic Store Optimization
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    persistent = true;
    options = "--delete-older-than 7d";
  };

  ########### Networking Configuration #################

  security.sudo.extraConfig = ''
    Defaults env_keep+=SSH_AUTH_SOCK
    Defaults env_keep+=HOME
  '';

  networking.firewall.allowedTCPPorts = [ 57621 ];
  networking.firewall.allowedUDPPorts = [ 5353 ];
}
