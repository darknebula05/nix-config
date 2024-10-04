{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.services.cachix;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.services.cachix.enable = mkEnableOption "cachix";

  config = {
    services.cachix-agent.enable = mkIf cfg.enable true;
  };
}
