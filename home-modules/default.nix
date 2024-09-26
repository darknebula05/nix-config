{
  lib,
  osConfig,
  ezModules,
  ...
}:
{
  imports = lib.attrValues {
    inherit (ezModules) sh helix stylix;
  };

  home.username = "${osConfig.variables.username}";
  home.homeDirectory = "/home/${osConfig.variables.username}";
  home.stateVersion = "24.05";
  fonts.fontconfig.enable = true;
}
