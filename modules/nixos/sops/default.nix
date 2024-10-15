{
  lib,
  pkgs,
  namespace,
  inputs,
  config,
  ...
}:
let
  cfg = config.${namespace}.sops;
  imp = config.${namespace}.impermanence;
in
with lib;
with lib.${namespace};
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.${namespace}.sops = {
    enable = mkEnableOption "sops";
    sshKeyPaths = mkOption {
      type = with types; listOf str;
      default =
        let
          prefix = (if imp.enable then imp.path else "");
        in
        [
          "${prefix}/etc/ssh/ssh_host_ed25519_key"
          "${prefix}/etc/ssh/ssh_host_rsa_key"
        ];
    };
    defaultSopsFile = mkOption {
      type = types.path;
      default = snowfall.fs.get-file "secrets/default.yaml";
    };
    keyFile = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    sops = {
      inherit (cfg) defaultSopsFile;
      age = {
        inherit (cfg) sshKeyPaths;
        keyFile = mkIf (cfg.keyFile != null) cfg.keyFile;
      };
    };
  };
}
