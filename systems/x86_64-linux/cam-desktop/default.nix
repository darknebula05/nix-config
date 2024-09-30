{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  ...
}:
{
  imports = [
    ./configuration.nix
  ];

  ${namespace}.variables = {
    username = "cameron";
    ewwDir = ./eww;
    flakeDir = "/home/cameron/.dotfiles/nix";
  };
}
