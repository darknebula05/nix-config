{
  pkgs,
  lib,
  osConfig,
  inputs,
  ...
}:
{
  imports = lib.optional (!osConfig ? stylix) inputs.stylix.homeManagerModules.stylix;
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };
  qt.enable = true;
}
