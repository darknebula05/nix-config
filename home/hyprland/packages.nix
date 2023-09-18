{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
    wofi
    brightnessctl
    hyprpaper
    sway-contrib.grimshot
    pamixer
  ];
}
