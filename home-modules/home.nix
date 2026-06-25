{ config, pkgs, lib, username, ... }:
{
  imports = [
    ./compositor.nix
    ./terminal.nix
    ./editor.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05";
  home.sessionPath = [ "$HOME/.local/bin" ];

  programs.home-manager.enable = true;
}
