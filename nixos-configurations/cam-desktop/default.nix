{ ezModules, ... }:
{
  imports = [
    ./configuration.nix
    ezModules.keyd
  ];

  variables = {
    username = "cameron";
    ewwDir = ./eww;
    flakeDir = "/home/cameron/.dotfiles/nix";
  };
}
