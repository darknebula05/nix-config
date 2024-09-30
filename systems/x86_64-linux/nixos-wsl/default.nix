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
    wsl = enabled;
    variables = {
      username = "cshearer";
      flakeDir = "/home/cshearer/dotfiles/nix";
    };
  };

  system.stateVersion = "24.05";
}
