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
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  ${namespace} = {
    keyd = enabled;
    variables = {
      username = "cameron";
      ewwDir = ./eww;
      flakeDir = "/home/cameron/dotfiles/nix";
    };
  };
}
