{
  lib,
  pkgs,
  namespace,
  inputs,
  config,
  ...
}:
let
  cfg = config.${namespace}.services.tailscale;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.services.tailscale.enable = mkEnableOption "tailscale";

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      authKeyFile = config.sops.secrets.tailscale.path;
      useRoutingFeatures = "both";
    };

    sops.secrets."tailscale" = { };
  };
}
