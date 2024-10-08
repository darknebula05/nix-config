{
  flake,
  lib,
  pkgs,
  ...
}:
with lib;
with flake.lib;
{
  home.packages = with pkgs; [
    distrobox
    tigervnc
    waypipe
    moonlight-qt
  ];

  services = {
    dunst = enabled;
    syncthing = enabled;
  };

  programs = {
    home-manager = enabled;
    fish = enabled;
    nix-index = enabled;
    nushell = enabled;
    starship = enabled;
  };
}
