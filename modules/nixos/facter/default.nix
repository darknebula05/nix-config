{
  lib,
  pkgs,
  namespace,
  inputs,
  config,
  ...
}:
let
  cfg = config.${namespace}.facter;
in
with lib;
with lib.${namespace};
{
  imports = [ inputs.nixos-facter-modules.nixosModules.facter ];

  options.${namespace}.facter = {
    enable = mkEnableOption "facter";
    path = mkOption {
      type = types.path;
    };
  };

  config = mkIf cfg.enable {
    facter.reportPath = cfg.path;
  };
}
