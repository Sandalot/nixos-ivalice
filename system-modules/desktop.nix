{ config, pkgs, lib, username, ... }:
{
  options.modules.desktop.enable = lib.mkEnableOption "desktop";

  config = lib.mkIf config.modules.desktop.enable {

    # Window Manager
    programs.niri.enable = true;

    # DMS Shell
    programs.dms-shell = {
      enable = true;
      systemd = {
        enable = true;
        restartIfChanged = true;
      };
      enableSystemMonitoring = true;
      enableDynamicTheming = true;
    };

    # Display Manager
    services.displayManager.dms-greeter = {
      enable = true;
      compositor = { name = "niri"; };
      configHome = "/home/${username}";
      configFiles = [ "/home/${username}/.config/DankMaterialShell/settings.json" ];
    };

    # Fonts
    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      nerd-fonts.iosevka
    ];

    # Portals
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    # File Manager
    services.gvfs.enable = true;
  };
}
