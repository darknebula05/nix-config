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
{
  imports = [
    ./configuration.nix
  ];

  ${namespace} = {
    keyd = enabled;
    variables = {
      username = "cameron";
      ewwDir = ./eww;
      flakeDir = "/home/cameron/.dotfiles/nix";
    };
  };
}
