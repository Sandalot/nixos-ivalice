{ config, pkgs, lib, ... }:
{
  options.modules.desktop.enable = lib.mkEnableOption "desktop";

  config = lib.mkIf config.modules.desktop.enable {

    # Window Manager
    programs.niri.enable = true;

    # Fonts
    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      nerd-fonts.iosevka
    ];

    # Icon Pack
    environment.systemPackages = with pkgs; [
      papirus-icon-theme
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
