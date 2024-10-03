{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.wsl;
in
with lib;
with lib.${namespace};
{
  imports = [ inputs.nixos-wsl.nixosModules.default ];

  options.${namespace}.wsl.enable = mkEnableOption "wsl";

  config.wsl = mkIf cfg.enable {
    enable = true;
    defaultUser = config.${namespace}.variables.username;
    useWindowsDriver = true;
  };
}
