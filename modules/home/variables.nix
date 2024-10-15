{
  lib,
  config,
  ...
}:
with lib;
{
  options.camms.variables = {
    ewwDir = mkOption {
      type = types.nullOr types.path;
      default = null;
    };
  };
}
