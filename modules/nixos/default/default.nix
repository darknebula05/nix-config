{
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
with lib.camms;
{
  imports = [ inputs.disko.nixosModules.disko ];

  options.camms.default.enable = mkEnableOption "Default options" // {
    default = true;
  };

  config = mkIf cfg.enable {
    services.automatic-timezoned = enabled;

    programs.fish = enabled;
  };
}
