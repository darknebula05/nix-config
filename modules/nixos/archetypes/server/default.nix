{
  lib,
  pkgs,
  namespace,
  inputs,
  config,
  ...
}:
let
  cfg = config.${namespace}.archetypes.server;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.archetypes.server.enable = mkEnableOption "server archetype";

  config = mkIf cfg.enable {
    ${namespace}.suites = {
      common = enabled;
    };
  };
}
