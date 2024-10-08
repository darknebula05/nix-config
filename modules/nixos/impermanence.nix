{
  flake,
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.impermanence;
in
with lib;
with flake.lib;
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.camms.impermanence = {
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
