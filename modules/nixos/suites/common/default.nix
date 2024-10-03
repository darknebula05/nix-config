{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.suites.common;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.suites.common.enable = mkEnableOption "desktop suite";

  config = mkIf cfg.enable {
    ${namespace} = {
      services.cachix = mkDefault enabled;
      services.tailscale = mkDefault enabled;
      nix = mkDefault enabled;
    };
  };
}
