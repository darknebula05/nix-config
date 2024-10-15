{
  lib,
  pkgs,
  namespace,
  inputs,
  config,
  ...
}:
let
  cfg = config.${namespace}.default;
in
with lib;
with lib.${namespace};
{
  imports = [ inputs.disko.nixosModules.disko ];

  options.${namespace}.default.enable = mkEnableOption "Default options" // {
    default = true;
  };

  config = mkIf cfg.enable {
    services.automatic-timezoned = enabled;

    programs.fish = enabled;
  };
}
