{ config, pkgs, ... }:

{
  imports = [
    ./hyprland
    ./helix
    ./services
  ];

  home = {
    username = "cameron";
    homeDirectory = "/home/cameron";

    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;
}
