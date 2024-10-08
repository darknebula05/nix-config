{
  flake,
  lib,
  config,
  ...
}:
with lib;
with flake.lib;
{
  options.camms.variables = {
    ewwDir = mkOption {
      type = types.nullOr types.path;
      default = null;
    };
  };
}
