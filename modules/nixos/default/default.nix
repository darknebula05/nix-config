{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.default;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.default.enable = mkOption {
    type = types.bool;
    description = "Default options";
    default = true;
  };

  config = mkIf cfg.enable {
    services.automatic-timezoned = enabled;

    programs.fish = enabled;
  };
}
