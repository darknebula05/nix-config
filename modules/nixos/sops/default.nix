{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.sops;
in
with lib;
with lib.${namespace};
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.${namespace}.sops = {
    enable = mkEnableOption "sops";
    sshKeyPaths = mkOption {
      type = with types; listOf str;
      default = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };
    defaultSopsFile = mkOption {
      type = types.path;
      default = lib.snowfall.fs.get-file "secrets/default.yaml";
    };
  };

  config = {
    ${namespace}.sops.enable = mkDefault true;
    sops = mkIf cfg.enable {
      inherit (cfg) defaultSopsFile;
      age = {
        inherit (cfg) sshKeyPaths;
        keyFile = "${
          config.users.users.${config.${namespace}.variables.username}.home
        }/.config/sops/age/keys.txt";
      };
    };
  };
}
