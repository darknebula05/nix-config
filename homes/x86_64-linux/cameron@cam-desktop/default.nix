{
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
{
  camms = {
    browser = enabled;
    hyprland = enabled;
    programs = enabled;
  };
}
