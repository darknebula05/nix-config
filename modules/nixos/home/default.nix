{
  lib,
  pkgs,
  inputs,
  namespace,
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

  options.${namespace}.home.enable = mkEnableOption "home";

  config.home-manager = mkIf cfg.enable {
    useUserPackages = true;
    useGlobalPkgs = true;
  };
}
