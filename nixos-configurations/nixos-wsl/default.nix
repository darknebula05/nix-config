{ ezModules, ... }:
{
  imports = [
    ./configuration.nix
    ezModules.wsl
  ];

  variables = {
    username = "cshearer";
    flakeDir = "/home/cshearer/dotfiles/nix";
  };

  system.stateVersion = "24.05";
}
