{
  lib,
  config,
  ...
}:
with lib;
with lib.camms;
{
  options.camms.variables = {
    ewwDir = mkOption {
      type = types.nullOr types.path;
      default = null;
    };
  };
}
