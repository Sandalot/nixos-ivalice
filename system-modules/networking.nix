{ ... }:
{
  networking.hostName = "Ivalice";
  networking.networkmanager.enable = true;

  # Caddy Cert for Homelab
  security.pki.certificateFiles = [
    ../certs/caddy-local-ca.crt
  ];

  # Spotify Connect
  networking.firewall.allowedTCPPorts = [ 57621 ];
  networking.firewall.allowedUDPPorts = [ 5353 ];
}
