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
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  ${namespace}.variables = {
    username = "cameron";
    ewwDir = ./eww;
    flakeDir = "/home/cameron/dotfiles/nix";
  };
}
