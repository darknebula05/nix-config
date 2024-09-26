{ pkgs, ... }:
{
  home.packages = with pkgs; [
    blender-hip
    bottles
    discord
    jellyfin-media-player
    libreoffice
    okular
    # obsidian
    prismlauncher
    # telegram-desktop
  ];

  programs = {
    kitty.enable = true;
    zathura.enable = true;
  };

  services = {
    dunst.enable = true;
    easyeffects.enable = true;
    syncthing.enable = true;
  };
}
