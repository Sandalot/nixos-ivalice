{ config, pkgs, lib, ... }:
{
  options.modules.terminal.enable = lib.mkEnableOption "terminal";

  config = lib.mkIf config.modules.terminal.enable {

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

    # Kitty
    home.file.".config/kitty/kitty.conf".text = ''
      include dank-tabs.conf
      include dank-theme.conf

      # Window
      hide_window_decorations yes
      window_padding_width 12
      confirm_os_window_close 0

      # Scrolling
      scrollback_lines 5000

      # Cursor
      cursor_shape beam
      cursor_blink_interval 0.5
      cursor_stop_blinking_after 0
      cursor_shape_unfocused hollow

      # Smooth caret animation (kitty's animated cursor trail)
      cursor_trail 1
      cursor_trail_decay 0.1 0.4
      cursor_trail_start_threshold 2

      # Font
      font_family      Iosevka Nerd Font Mono
      bold_font        Iosevka Nerd Font Mono Bold
      italic_font      Iosevka Nerd Font Mono Italic
      bold_italic_font Iosevka Nerd Font Mono Bold Italic
      font_size 12.0

      # Mouse 
      mouse_hide_wait 3.0

      # Selection 
      copy_on_select no

      # Bell
      enable_audio_bell no

      # Keybindings
      map ctrl+shift+c copy_to_clipboard
      map ctrl+shift+v paste_from_clipboard
      map ctrl+shift+n new_os_window
      map ctrl+shift+equal change_font_size all +1.0
      map ctrl+minus change_font_size all -1.0
      map ctrl+0 change_font_size all 0
      map shift+enter send_text all \n
     '';
  };
}
