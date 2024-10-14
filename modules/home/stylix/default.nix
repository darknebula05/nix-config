{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.stylix;
in
with lib;
with lib.camms;
{
  options.camms.stylix.enable = mkEnableOption "stylix";

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
