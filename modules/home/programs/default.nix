{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  osConfig,
  ...
}:
let
  cfg = config.${namespace}.programs;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.programs.enable = mkEnableOption "programs";

  config = mkIf cfg.enable {
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
