{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.services.keyd;
in
with lib;
with lib.camms;
{
  options.camms.services.keyd.enable = mkEnableOption "keyd";

  config.services.keyd = mkIf cfg.enable {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "layer(capslock)";
          };
          "capslock:C" = {
            "[" = "esc";
          };
        };
      };
    };
  };
}
