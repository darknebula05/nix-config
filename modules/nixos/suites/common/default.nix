{
  lib,
  pkgs,
  namespace,
  inputs,
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
      nix = mkDefault enabled;
      services.cachix = mkDefault enabled;
      services.tailscale = mkDefault enabled;
      sops = mkDefault enabled;
      user = mkDefault enabled;
    };
  };
}
