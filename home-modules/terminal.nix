{ config, pkgs, ... }:
{
  # Fish Shell
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      /run/current-system/sw/bin/fetch
      set fish_greeting ""
      echo -e "\033[5 q"
    '';
  };

  # Starship Prompt
  programs.starship = {
    enable = true;
    settings = {
      format = "$hostname$time$directory$git_branch$git_status$character";

      hostname = {
        ssh_only = false;
        format = "[$hostname]($style) | ";
        style = "bold white";
      };

      time = {
        disabled = false;
        format = "[$time]($style) ❭ ";
        time_format = "%H:%M";
        style = "dimmed white";
      };

      directory = {
        format = "[$path]($style) ";
        style = "purple";
        truncation_length = 2;
        truncate_to_repo = true;
      };

      git_branch = {
        format = "❭ [ $branch]($style) ";
        style = "blue";
      };

      git_status = {
        format = "[$all_status$ahead_behind]($style)";
        style = "green";
      };

      character = {
        success_symbol = "\n[❯](bold purple)";
        error_symbol = "\n[❯](bold red)";
      };
    };
  };

  # Areofyl Fetch
  home.file.".config/fetch/config".text = ''
    label_color=magenta
    separator=-
    size=0.6
    height=15
    os
    kernel
    uptime
    packages
    terminal
    font

    cpu
    gpu
    memory
  '';

  # Fastfetch
  home.file.".config/fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "logo": {
        "source": "nixos_small",
        "padding": {
          "top": 2,
          "right": 2,
          "left": 2
        }
      }
    }
  '';

  # Alacritty
  home.file.".config/alacritty/alacritty.toml".text = ''
    [general]
    import = [
      "~/.config/alacritty/dank-theme.toml"
    ]

    [window]
    decorations = "None"
    padding = { x = 12, y = 12 }

    [scrolling]
    history = 5000

    [cursor]
    style = { shape = "Beam", blinking = "On" }
    blink_interval = 500
    unfocused_hollow = true

    [font]
    normal = { family = "Iosevka Nerd Font Mono", style = "Regular" }
    bold = { family = "Iosevka Nerd Font Mono", style = "Bold" }
    italic = { family = "Iosevka Nerd Font Mono", style = "Italic" }
    bold_italic = { family = "Iosevka Nerd Font Mono", style = "Bold Italic" }
    size = 12.0

    [mouse]
    hide_when_typing = true

    [selection]
    save_to_clipboard = false

    [bell]
    duration = 0

    [keyboard]
    bindings = [
      { key = "C",      mods = "Control|Shift", action = "Copy"  },
      { key = "V",      mods = "Control|Shift", action = "Paste" },
      { key = "N",      mods = "Control|Shift", action = "SpawnNewInstance" },
      { key = "Equals", mods = "Control|Shift", action = "IncreaseFontSize" },
      { key = "Minus",  mods = "Control",       action = "DecreaseFontSize" },
      { key = "Key0",   mods = "Control",       action = "ResetFontSize"    },
      { key = "Enter",  mods = "Shift",         chars = "\n" },
    ]
  '';
}
