{
  flake,
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
with lib;
with flake.lib;
{
  imports = [ flake.nixosModules.all ];

  camms = {
    facter = {
      enable = true;
      path = ./facter.json;
    };
    home = {
      enable = true;
      path = ./home.nix;
    };
    suites.common = enabled;
    wsl = enabled;
    stylix = enabled;
    variables = {
      username = "cshearer";
      flakeDir = "/home/cshearer/dotfiles/nix";
    };
  };

  system.stateVersion = "24.05";

  programs = {
    nix-ld = enabled;
  };

  networking.hostName = "nixos-wsl";
  users.defaultUserShell = pkgs.fish;
  users.users.cshearer = {
    extraGroups = [
      "wheel"
    ];
    isNormalUser = true;
  };

  fonts.packages = with pkgs; [ fira-code-nerdfont ];

  services = {
    avahi = enabled;
    openssh = enabled;
  };
}
