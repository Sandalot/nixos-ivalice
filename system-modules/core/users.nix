{ config, pkgs, username, ... }:
{
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  # Keep SSH agent / Wayland session vars alive across sudo
  security.sudo.extraConfig = ''
    Defaults env_keep+=SSH_AUTH_SOCK
    Defaults env_keep+=HOME
    Defaults env_keep += "WAYLAND_DISPLAY XDG_RUNTIME_DIR"
  '';
}
