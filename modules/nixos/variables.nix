{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.variables;
in
with lib;
{
  options.camms.variables = {
    username = mkOption {
      type = types.str;
    };
    flakeDir = mkOption {
      type = types.str;
      default = "/home/${cfg.username}/.config/nixos/";
    };
  };
}
