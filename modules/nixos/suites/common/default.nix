{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.suites.common;
in
with lib;
with lib.camms;
{
  options.camms.suites.common.enable = mkEnableOption "desktop suite";

  config = mkIf cfg.enable {
    camms = {
      stylix.enable = mkForce false;
      nix = mkDefault enabled;
      services.cachix = mkDefault enabled;
      services.tailscale = mkDefault enabled;
      sops = mkDefault enabled;
      user = mkDefault enabled;
    };
  };
}
