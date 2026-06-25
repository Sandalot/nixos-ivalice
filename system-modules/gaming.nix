{ config, pkgs, lib, ... }:
{
  options.modules.gaming.enable = lib.mkEnableOption "gaming";

  config = lib.mkIf config.modules.gaming.enable {

    # Steam
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
    };

    # Game Optimizations
    programs.gamemode.enable = true;
  };
}
