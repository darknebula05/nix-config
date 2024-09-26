{
  pkgs,
  lib,
  osConfig,
  inputs,
  ...
}:
{
  imports = lib.optional (!osConfig ? stylix) inputs.stylix.homeManagerModules.stylix;
  stylix.targets.helix.enable = false;
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };
  qt.enable = true;
}
