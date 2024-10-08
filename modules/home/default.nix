{
  flake,
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.default;
in
with lib;
with flake.lib;
{
  options.camms.default.enable = mkOption {
    type = types.bool;
    description = "Default options";
    default = true;
  };

  config = {
    camms = mkIf cfg.enable {
      sh = mkDefault enabled;
      helix = mkDefault enabled;
      stylix = mkDefault enabled;
    };
    home.stateVersion = "24.05";
    fonts.fontconfig = enabled;
  };
}
