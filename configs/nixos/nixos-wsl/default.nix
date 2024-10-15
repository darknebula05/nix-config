{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
with lib;
{
  camms = {
    facter = {
      enable = true;
      path = ./facter.json;
    };
    suites.common.enable = true;
    wsl.enable = true;
    stylix.enable = true;
    variables = {
      username = "cshearer";
      flakeDir = "/home/cshearer/dotfiles/nix";
    };
  };

  system.stateVersion = "24.05";

  programs = {
    nix-ld.enable = true;
  };

  networking.hostName = "nixos-wsl";

  fonts.packages = with pkgs; [ fira-code-nerdfont ];

  services = {
    avahi.enable = true;
    openssh.enable = true;
  };
}
