{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.impermanence;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.impermanence = {
    enable = mkEnableOption "impermanence";
    path = mkOption {
      type = types.str;
      default = "/nix/persist/system";
    };
  };
  config.environment.persistence.${cfg.path} = mkIf cfg.enable {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

}
