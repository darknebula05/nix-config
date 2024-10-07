{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace};
let
  user = "cameron";
in
{
  imports = [
    ./configuration.nix
    # ./disko.nix
  ];

  ${namespace} = {
    archetypes.workstation = enabled;
    services.arrs = enabled;
    variables = {
      username = "${user}";
      flakeDir = "/home/cameron/.dotfiles/nix";
    };
  };
  snowfallorg.users.${user}.home.config.${namespace}.variables.ewwDir = ./eww;
}
