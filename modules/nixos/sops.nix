{
  flake,
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.sops;
in
with lib;
with flake.lib;
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.camms.sops = {
    enable = mkEnableOption "sops";
    sshKeyPaths = mkOption {
      type = with types; listOf str;
      default = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };
    defaultSopsFile = mkOption {
      type = types.path;
      default = "${inputs.self}/secrets/default.yaml";
    };
  };

  config = {
    camms.sops.enable = mkDefault true;
    sops = mkIf cfg.enable {
      inherit (cfg) defaultSopsFile;
      age = {
        inherit (cfg) sshKeyPaths;
        keyFile = "${config.users.users.${config.camms.variables.username}.home}/.config/sops/age/keys.txt";
      };
    };
  };
}
