{
  lib,
  pkgs,
  namespace,
  inputs,
  config,
  ...
}:
let
  cfg = config.${namespace}.variables;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.variables = {
    username = mkOption {
      type = types.str;
    };
    flakeDir = mkOption {
      type = types.str;
      default = "/home/${cfg.username}/.config/nixos/";
    };
  };
}
