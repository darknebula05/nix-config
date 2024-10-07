{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.archetypes.workstation;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.archetypes.workstation.enable = mkEnableOption "workstation archetype";

  config = mkIf cfg.enable {
    ${namespace}.suites = {
      common = enabled;
      desktop = enabled;
    };
  };
}
