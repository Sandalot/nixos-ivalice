{ config, pkgs, lib, username, ... }:
{
  options.modules.dms-greeter.enable = lib.mkEnableOption "dms-greeter";

  config = lib.mkIf config.modules.dms-greeter.enable {
    services.displayManager.dms-greeter = {
      enable = true;
      compositor = { name = "niri"; };
      configHome = "/home/${username}";
      configFiles = [ "/home/${username}/.config/DankMaterialShell/settings.json" ];
    };
  };
}
