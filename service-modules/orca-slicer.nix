{ config, pkgs, lib, ... }:

let
  pname = "orca-slicer";
  version = "2.4.2";

  src = pkgs.fetchurl {
    url = "https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.4.2/OrcaSlicer_Linux_AppImage_Ubuntu2404_V2.4.2.AppImage";
    sha256 = "sha256-0S+4yOrBrs0t+2N3rNSPmU+PpDntUpL6Uy3YKIDwKf0=";
  };

  appimageContents = pkgs.appimageTools.extractType2 { inherit pname version src; };

  orca-slicer-unwrapped = pkgs.appimageTools.wrapType2 {
    inherit pname version src;
    extraPkgs = pkgs: with pkgs; [
      webkitgtk_4_1
      libsoup_3
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-libav
    ];
    extraInstallCommands = ''
      desktopFile=$(find ${appimageContents} -maxdepth 1 -name "*.desktop" | head -n1)
      install -m 444 -D "$desktopFile" $out/share/applications/orca-slicer.desktop
      substituteInPlace $out/share/applications/orca-slicer.desktop \
        --replace "Exec=AppRun" "Exec=orca-slicer"

      iconFile=$(find ${appimageContents} -maxdepth 1 \( -name "*.png" -o -name "*.svg" \) | head -n1)
      if [ -n "$iconFile" ]; then
        install -m 444 -D "$iconFile" $out/share/icons/hicolor/256x256/apps/orca-slicer.png
      fi
    '';
  };

  orca-slicer-appimage = pkgs.symlinkJoin {
    name = "orca-slicer";
    paths = [ orca-slicer-unwrapped ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/orca-slicer \
        --set GTK_THEME "Adwaita:dark"
    '';
  };
in
{
  environment.systemPackages = [
    orca-slicer-appimage
  ];

  networking.firewall = {
    allowedTCPPorts = [ 990 8883 ];
    allowedUDPPorts = [ 1990 2021 ];
  };
}
