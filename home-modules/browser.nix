{ config, pkgs, lib, ... }:

let
  cfg = config.modules.browser.zen;
in
{
  options.modules.browser.zen = {
    enable = lib.mkEnableOption "Custom Zen Browser configuration with DMS integration";
  };

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;

      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;

        search = {
          default = "google";
          force = true;
        };

        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "font.name.serif.x-western" = "Iosevka Nerd Font";
          "font.name.sans-serif.x-western" = "Iosevka Nerd Font";
          "font.name.monospace.x-western" = "Iosevka Nerd Font";

          # Open to Glance on Startup
          "browser.startup.homepage" = "http://glance.home.lab";
          "browser.startup.page" = 1;
          "browser.newtab.url" = "http://glance.home.lab";
          "browser.newtabpage.enabled" = false;
        };
      };

      policies = {
        Certificates = {
          ImportEnterpriseRoots = true;
        };

        ExtensionSettings = {
          "uBlock0@raymondhill.net" = { installation_mode = "force_installed"; install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"; };
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = { installation_mode = "force_installed"; install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi"; };
          "sponsorBlocker@ajay.app" = { installation_mode = "force_installed"; install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi"; };
        };
      };
    };

    # UI Configuration (Chrome)
    home.file.".zen/7o3g1h0b.Default Profile/chrome/userChrome.css" = {
      text = ''
        @import url("file://${config.home.homeDirectory}/.config/DankMaterialShell/zen.css");

        * {
          font-family: "Iosevka Nerd Font" !important;
          font-size: 15px !important;
        }

        #sidebar-box,
        #sidebar-header,
        .sidebar-panel,
        .tab-label,
        .sidebar-item-text {
          font-family: "Iosevka Nerd Font" !important;
        }
      '';
    };

    # Content Configuration (Website body)
    home.file.".zen/7o3g1h0b.Default Profile/chrome/userContent.css" = {
      text = ''
        body, html, p, span, div, h1, h2, h3, h4, h5, h6, a, li, td {
          font-family: "Iosevka Nerd Font";
        }
      '';
    };
  };
}
