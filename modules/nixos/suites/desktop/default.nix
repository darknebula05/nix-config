{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.suites.desktop;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.suites.desktop.enable = mkEnableOption "desktop suite";

  config = mkIf cfg.enable {
    ${namespace} = {
      home = mkDefault enabled;
      impermanence = mkDefault enabled;
      services.keyd = mkDefault enabled;
      stylix = mkDefault enabled;
    };
  };
}
