{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.home;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.camms.home = {
    enable = mkEnableOption "home";
    name = mkOption {
      type = types.str;
      default = config.camms.variables.username;
    };
  };

  config.home-manager = mkIf cfg.enable {
    useUserPackages = true;
    useGlobalPkgs = true;
  };
}
