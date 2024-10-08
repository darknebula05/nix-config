{
  flake,
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.archetypes.workstation;
in
with lib;
with flake.lib;
{
  options.camms.archetypes.workstation.enable = mkEnableOption "workstation archetype";

  config = mkIf cfg.enable {
    camms.suites = {
      common = enabled;
      desktop = enabled;
    };
  };
}
