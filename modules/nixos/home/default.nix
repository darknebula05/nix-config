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
with lib.camms;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.camms.home = {
    enable = mkEnableOption "home";
    path = mkOption {
      type = types.nullOr types.path;
      default = null;
    };
    name = mkOption {
      type = types.str;
      default = config.camms.variables.username;
    };
  };

  config.home-manager = mkIf cfg.enable {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${cfg.name} = mkIf (cfg.path != null) (import cfg.path);
    extraSpecialArgs = {
      inherit inputs;
    };
  };
}
