{
  flake,
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
with flake.lib;
{
  options.camms.suites.common.enable = mkEnableOption "desktop suite";

  config = mkIf cfg.enable {
    camms = {
      nix = mkDefault enabled;
      services.cachix = mkDefault enabled;
      services.tailscale = mkDefault enabled;
      sops = mkDefault enabled;
      user = mkDefault enabled;
    };
  };
}
