{ lib, config, ... }:
with lib;
{
  options.variables = {
    username = mkOption {
      type = types.str;
    };
    flakeDir = mkOption {
      type = types.str;
      default = "/home/${config.variables.username}/.config/nixos/";
    };
    ewwDir = mkOption {
      type = types.nullOr types.path;
      default = null;
    };
  };
}
