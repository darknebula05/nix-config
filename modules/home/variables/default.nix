{
  lib,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace};
{
  options.${namespace}.variables = {
    ewwDir = mkOption {
      type = types.nullOr types.path;
      default = null;
    };
  };
}
