{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  osConfig,
  ...
}:
let
  cfg = config.${namespace}.stylix;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.stylix.enable = mkEnableOption "stylix";

  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
    };
    qt = enabled;
  };
}
