{
  flake,
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.user;
  sops = config.camms.sops.enable;
in
with lib;
with flake.lib;
{
  options.camms.user = {
    enable = mkEnableOption "user";
    admin = mkOption {
      type = types.bool;
      default = true;
    };
    extraGroups = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
    hashedPasswordFile = mkOption {
      type = types.str;
    };
    defaultUserShell = mkOption {
      type = types.package;
      default = pkgs.fish;
    };
  };

  config = mkIf cfg.enable {
    users = {
      mutableUsers = false;
      inherit (cfg) defaultUserShell;
      users.${config.camms.variables.username} = {
        isNormalUser = true;
        extraGroups = optional (cfg.admin) "wheel" ++ cfg.extraGroups;
        inherit (cfg) hashedPasswordFile;
      };
    };
    camms.user.hashedPasswordFile = mkIf sops (mkDefault config.sops.secrets.hashed_password.path);
    sops.secrets.hashed_password.neededForUsers = mkIf sops true;
  };
}
