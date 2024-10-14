{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.archetypes.server;
in
with lib;
with lib.camms;
{
  options.camms.archetypes.server.enable = mkEnableOption "server archetype";

  config = mkIf cfg.enable {
    camms.suites = {
      common = enabled;
    };
  };
}
