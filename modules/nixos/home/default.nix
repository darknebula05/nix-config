{
  lib,
  pkgs,
  namespace,
  inputs,
  config,
  ...
}:
let
  cfg = config.${namespace}.home;
in
with lib;
with lib.${namespace};
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.${namespace}.home = {
    enable = mkEnableOption "home";
    path = mkOption {
      type = types.nullOr types.path;
      default = null;
    };
    name = mkOption {
      type = types.str;
      default = config.${namespace}.variables.username;
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
