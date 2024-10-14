{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.services.cachix;
in
with lib;
with lib.camms;
{
  options.camms.services.cachix.enable = mkEnableOption "cachix";

  config = {
    services.cachix-agent.enable = mkIf cfg.enable true;
  };
}
