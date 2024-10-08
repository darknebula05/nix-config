{
  flake,
  lib,
  pkgs,
  ...
}:
with lib;
with flake.lib;
{
  camms = {
    browser = enabled;
    hyprland = enabled;
    programs = enabled;
    variables.ewwDir = ./eww;
  };
}
