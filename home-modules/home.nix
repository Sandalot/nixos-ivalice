{ config, pkgs, lib, username, inputs, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.beta
    ./compositor.nix
    ./terminal.nix
    ./editor.nix
    ./media.nix
    ./browser.nix
  ];

  # Modules
  modules.compositor.enable = true;
  modules.media.enable = true;
  modules.browser.zen.enable = true;

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05";
  home.sessionPath = [ "$HOME/.local/bin" ];

  programs.home-manager.enable = true;
}
