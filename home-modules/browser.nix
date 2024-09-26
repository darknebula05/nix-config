{ pkgs, ... }:
{
  programs = {
    chromium = {
      enable = true;
      package = pkgs.brave;
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        "--gtk-version=4"
      ];
    };
    firefox = {
      enable = true;
    };
  };
}
