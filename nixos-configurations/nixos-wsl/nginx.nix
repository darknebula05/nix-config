{ pkgs, ... }:
{
  services.nginx = {
    enable = true;
    virtualHosts."cms-server" = {
      locations =
        let
          host = "100.110.162.72";
        in
        {
          "/".tryFiles = "$uri $uri/ =404";
          "/jellyfin".return = "302 $scheme://$host/jellyfin/";
          "/jellyfin/" = {
            proxyPass = "http://${host}:8096";
            recommendedProxySettings = true;
            proxyWebsockets = true;
          };
          "^~ /radarr" = {
            proxyPass = "http://${host}:7878";
            recommendedProxySettings = true;
            proxyWebsockets = true;
          };
          "^~ /radarr/api" = {
            proxyPass = "http://${host}:7878";
          };
        };
    };
  };
}
