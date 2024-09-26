{ inputs, ezModules, ... }:
{
  imports = [
    ./configuration.nix
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    ezModules.keyd
  ];

  variables = {
    username = "cameron";
    ewwDir = ./eww;
    flakeDir = "/home/cameron/dotfiles/nix";
  };
}
