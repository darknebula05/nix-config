{
  lib,
  pkgs,
  namespace,
  inputs,
  config,
  ...
}:
let
  cfg = config.${namespace}.stylix;
  theme = "catppuccin-mocha";
in
with lib;
with lib.${namespace};
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  options.${namespace}.stylix.enable = mkEnableOption "stylix";

  config.stylix = mkIf cfg.enable {
    enable = true;
    image =
      if config.networking.hostName or "" == "cam-laptop" then
        ./wallpapers/death_star.jpg
      else
        ./wallpapers/black-sand-dunes.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
    cursor = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };
    targets.gtk = enabled;
  };
}
