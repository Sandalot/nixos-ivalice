{ config, pkgs, lib, username, ... }:
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
  home.sessionPath = [ "$HOME/.local/bin" ];

  # Run dms setup on first boot
  systemd.user.services.dms-first-boot = {
    Unit = {
      Description = "DMS first boot setup";
      After = [ "graphical-session.target" ];
      ConditionPathExists = "!%h/.config/DankMaterialShell/settings.json";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.dms-shell}/bin/dms setup";
      RemainAfterExit = true;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Niri (DMS manages its own dms/ subdirectory)
  home.file.".config/niri/config.kdl".text = ''
    config-notification {
        disable-failed
    }
    gestures {
        hot-corners {
            off
        }
    }

    input {
        keyboard {
            xkb {
            }
            numlock
        }
        touchpad {
            tap
            natural-scroll
        }
        mouse {
        }
        trackpoint {
        }
    }

    layout {
        background-color "transparent"
        center-focused-column "never"
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }
        default-column-width { proportion 0.5; }
        border {
            off
            width 4
            active-color   "#707070"
            inactive-color "#d0d0d0"
            urgent-color   "#cc4444"
        }
        shadow {
            softness 30
            spread 5
            offset x=0 y=5
            color "#0007"
        }
        struts {
        }
    }

    layer-rule {
        match namespace="^quickshell$"
        place-within-backdrop true
    }

    overview {
        workspace-shadow {
            off
        }
    }

    environment {
        XDG_CURRENT_DESKTOP "niri"
    }

    hotkey-overlay {
        skip-at-startup
    }

    prefer-no-csd
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    animations {
        workspace-switch {
            spring damping-ratio=0.80 stiffness=523 epsilon=0.0001
        }
        window-open {
            duration-ms 150
            curve "ease-out-expo"
        }
        window-close {
            duration-ms 150
            curve "ease-out-quad"
        }
        horizontal-view-movement {
            spring damping-ratio=0.85 stiffness=423 epsilon=0.0001
        }
        window-movement {
            spring damping-ratio=0.75 stiffness=323 epsilon=0.0001
        }
        window-resize {
            spring damping-ratio=0.85 stiffness=423 epsilon=0.0001
        }
        config-notification-open-close {
            spring damping-ratio=0.65 stiffness=923 epsilon=0.001
        }
        screenshot-ui-open {
            duration-ms 200
            curve "ease-out-quad"
        }
        overview-open-close {
            spring damping-ratio=0.85 stiffness=800 epsilon=0.0001
        }
    }

    window-rule {
        match app-id=r#"^org\.gnome\."#
        draw-border-with-background false
        geometry-corner-radius 12
        clip-to-geometry true
    }
    window-rule {
        match app-id=r#"^org\.gnome\.Calculator$"#
        match app-id=r#"^gnome-calculator$"#
        match app-id=r#"^galculator$"#
        match app-id=r#"^blueman-manager$"#
        match app-id=r#"^org\.gnome\.Nautilus$"#
        match app-id=r#"^xdg-desktop-portal$"#
        open-floating true
        opacity 0.8
        background-effect {
            blur true
        }
    }
    window-rule {
        match app-id=r#"^steam$"# title=r#"^notificationtoasts_\d+_desktop$"#
        default-floating-position x=10 y=10 relative-to="bottom-right"
        open-focused false
        opacity 0.8
        background-effect {
            blur true
        }
    }
    window-rule {
        match app-id="Alacritty"
        match app-id="zen"
        match app-id="com.mitchellh.ghostty"
        match app-id="kitty"
        draw-border-with-background false
    }
    window-rule {
        match app-id=r#"firefox$"# title="^Picture-in-Picture$"
        match app-id="zoom"
        open-floating true
    }
    window-rule {
        match app-id=r#"org.quickshell$"#
        match app-id=r#"com.danklinux.dms$"#
        open-floating true
    }
    window-rule {
        match app-id="^Alacritty$"
        opacity 0.8
        background-effect {
            blur true
        }
    }

    layer-rule {
        match namespace="^launcher$"
        opacity 0.7
        background-effect {
            blur true
        }
    }

    debug {
        honor-xdg-activation-with-invalid-serial
    }

    recent-windows {
        binds {
            Alt+Tab         { next-window scope="output"; }
            Alt+Shift+Tab   { previous-window scope="output"; }
            Alt+grave       { next-window filter="app-id"; }
            Alt+Shift+grave { previous-window filter="app-id"; }
        }
    }

    include "dms/colors.kdl"
    include "dms/layout.kdl"
    include "dms/alttab.kdl"
    include "dms/binds.kdl"
    include "dms/outputs.kdl"
    include "dms/cursor.kdl"
  '';

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

  # Neovim Setup
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-web-devicons
      nvim-tree-lua
      nvim-autopairs
      nvim-treesitter
      gitsigns-nvim
    ];
    initLua = ''
      vim.opt.number = true
      vim.opt.relativenumber = false
      vim.opt.termguicolors = false
      vim.opt.fillchars = { eob = " " }

      require("nvim-autopairs").setup()
      require("gitsigns").setup()

      vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

      vim.api.nvim_create_autocmd("BufReadPost", { callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
          vim.api.nvim_win_set_cursor(0, mark)
        end
      end })

      require("nvim-tree").setup({ view = { width = 30 } })
      vim.api.nvim_create_autocmd("VimEnter", { callback = function()
        require("nvim-tree.api").tree.open()
      end })
    '';
  };

  # Aerofyl Fetch
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
