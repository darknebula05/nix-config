{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.suites.desktop;
in
with lib;
with lib.camms;
{
  options.camms.suites.desktop.enable = mkEnableOption "desktop suite";

  config = mkIf cfg.enable {
    camms = {
      home = mkDefault enabled;
      impermanence = mkDefault enabled;
      services.keyd = mkDefault enabled;
      stylix = mkDefault enabled;
    };
  };
}
