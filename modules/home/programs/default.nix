{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.programs;
in
with lib;
with lib.camms;
{
  options.camms.programs.enable = mkEnableOption "programs";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # blender-hip
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
      kitty = enabled;
      zathura = enabled;
    };

    services = {
      dunst = enabled;
      easyeffects = enabled;
      syncthing = enabled;
    };
  };
}
