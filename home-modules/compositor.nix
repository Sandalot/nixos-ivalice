{ config, pkgs, lib, ... }:

{
  options.modules.compositor.enable = lib.mkEnableOption "compositor";

  config = lib.mkIf config.modules.compositor.enable {

    # Niri Config
    home.file.".config/niri/config.kdl".text = ''
      config-notification {
          disable-failed
      }
      
      // Skips hotkey overlay at startup
      hotkey-overlay {
          skip-at-startup
      }

      input {
          keyboard {
              xkb {
                // Swap capslock and escape for VIM users
                options "caps:swapescape"
          }
              numlock
          }
          touchpad {
              tap
              natural-scroll
          }
      }

      layout {
          background-color "transparent"
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

      prefer-no-csd
      screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

      // Disable the large drop shadows on workspaces in the overview
      overview {
          workspace-shadow {
              off
          }
      }

      // --- Window Rules ---
      // General GNOME / Portal transparency & radius
      window-rule {
          match app-id=r#"^org\.gnome\."#
          draw-border-with-background false
          geometry-corner-radius 12
          clip-to-geometry true
      }

      // Floating utilities
      window-rule {
          match app-id=r#"^org\.gnome\.(Calculator|Nautilus)$"#
          match app-id=r#"^(gnome-calculator|blueman-manager|xdg-desktop-portal)$"#
          open-floating true
          opacity 0.8
          background-effect {
              blur true
          }
          popups {
              geometry-corner-radius 10
              opacity 0.8
              background-effect {
                  blur true
                  xray false
              }
          }
      }

      // Zen Browser
      window-rule {
          match app-id=r#"^zen(-alpha|-beta)?$"#
          geometry-corner-radius 12
          clip-to-geometry true
          draw-border-with-background false
          opacity 0.9
          background-effect {
              blur true
          }
      }

      // Media (IMV, MPV)
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

      // Steam
      window-rule {
          match app-id="steam"
          geometry-corner-radius 12
          clip-to-geometry true
          opacity 0.9
          background-effect {
              blur true
          }
      }

     // Send Steam notifications/toasts to the bottom right corner
    window-rule {
          match app-id="^steam$" title="^notificationtoasts_.*$"
          open-floating true
          opacity 0.8
          default-floating-position x=10 y=10 relative-to="bottom-right"
          background-effect {
              blur true
          }
      }

      // Spotify
      window-rule {
          match app-id="Spotify"
          geometry-corner-radius 12
          clip-to-geometry true
          opacity 0.9
          background-effect {
              blur true
          }
      }

      // Terminal
      window-rule {
          match app-id="^kitty$"
          opacity 0.8
          background-effect {
              blur true
          }
      }

      // DMS/System UI
      window-rule {
          match app-id=r#"(org\.quickshell|com\.danklinux\.dms)$"#
          open-floating true
          opacity 0.8
          background-effect {
             blur true
          }
      }

     // --- Layers & Extras ---
      layer-rule {
          match namespace="^quickshell$"
          place-within-backdrop true
      }
      layer-rule {
          match namespace="^launcher$"
          opacity 0.7
          background-effect {
              blur true
          }
      }

      // Alt + Tab Binds
      recent-windows {
          binds {
              Alt+Tab { next-window scope="output"; }
              Alt+Shift+Tab { previous-window scope="output"; }
          }
      }

      // DMS Includes
      include "dms/colors.kdl"
      include "dms/layout.kdl"
      include "dms/alttab.kdl"
      include "dms/binds.kdl"
      include "dms/outputs.kdl"
      include "dms/cursor.kdl"
    '';
  };
}
