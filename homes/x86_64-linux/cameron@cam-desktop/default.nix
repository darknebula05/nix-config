{
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
{
  ${namespace} = {
    browser = enabled;
    hyprland = enabled;
    programs = enabled;
    variables.ewwDir = ./eww;
  };
}
