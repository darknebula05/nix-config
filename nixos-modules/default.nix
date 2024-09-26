{
  lib,
  ezModules,
  config,
  ...
}:
{
  imports = lib.attrValues {
    inherit (ezModules) stylix variables home;
  };

  services.automatic-timezoned.enable = true;
  programs = {
    fish.enable = true;
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3 --nogcroots";
      flake = config.variables.flakeDir;
    };
  };
}
