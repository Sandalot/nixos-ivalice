{ config, pkgs, lib, ... }:
{
  options.modules.media.enable = lib.mkEnableOption "user-media-apps";

  config = lib.mkIf config.modules.media.enable {
    
    # OBS Studio Configuration
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        # Place future OBS plugins here
      ];
    };

    # VLC Media Player
    home.packages = with pkgs; [
      vlc 
    ];
  };
}
