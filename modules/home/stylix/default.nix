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
  imports = optional (!osConfig ? stylix) inputs.stylix.homeManagerModules.stylix;

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
