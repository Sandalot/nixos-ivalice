{ config, pkgs, lib, username, inputs, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.beta
    inputs.dms.homeModules.dank-material-shell
    ./compositor.nix
    ./terminal.nix
    ./neovim.nix
    ./media.nix
    ./browser.nix
    ./dank-shell.nix
  ];

  # Modules
  modules.compositor.enable = true;
  modules.terminal.enable = true;
  modules.neovim.enable = true;
  modules.media.enable = true;
  modules.browser.zen.enable = true;
  modules.dms.enable = true;

  # Environment Variables
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05";
  home.sessionPath = [ "$HOME/.local/bin" ];

  programs.home-manager.enable = true;
}
