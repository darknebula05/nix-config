{
  lib,
  pkgs,
  ...
}:
with lib;
with lib.camms;
{
  camms = {
    browser = enabled;
    hyprland = enabled;
    programs = enabled;
    variables.ewwDir = ./eww;
  };
}
