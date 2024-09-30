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
  cfg = config.${namespace}.browser;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.browser.enable = mkEnableOption "browsers";

  config.programs = mkIf cfg.enable {
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
