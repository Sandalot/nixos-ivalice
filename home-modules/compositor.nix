{ config, pkgs, lib, ... }:
{
  options.modules.compositor.enable = lib.mkEnableOption "compositor";

  config = lib.mkIf config.modules.compositor.enable {

  # DMS First Boot Service
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

  # Niri Config
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
            numlock
        }
        touchpad {
            tap
            natural-scroll
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
        }
        shadow {
            softness 30
            spread 5
            offset x=0 y=5
            color "#0007"
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
        match app-id="imv"
        open-floating true
        opacity 0.8
        background-effect {
            blur true
        }
    }
    window-rule {
        match app-id="mpv"
        open-floating true
        opacity 0.95
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
        draw-border-with-background false
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
  };
}
