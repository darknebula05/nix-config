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

  facter.reportPath = ./facter.json;

  ${namespace} = {
    suites.common = enabled;
    wsl = enabled;
    stylix = enabled;
    variables = {
      username = "cshearer";
      flakeDir = "/home/cshearer/dotfiles/nix";
    };
  };

  system.stateVersion = "24.05";
}
