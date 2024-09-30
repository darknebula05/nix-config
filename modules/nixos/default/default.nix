{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.default;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.default.enable = mkOption {
    type = types.bool;
    description = "Default options";
    default = true;
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      home = enabled;
      cachix = enabled;
      stylix = enabled;
    };

    services.automatic-timezoned = enabled;

    programs = {
      fish = enabled;
      nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep-since 4d --keep 3 --nogcroots";
        };
        flake = config.${namespace}.variables.flakeDir;
      };
    };

    nixpkgs = {
      config.allowUnfree = true;
    };

    nix = {
      settings = {
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [
          "@wheel"
        ];
        substituters = [
          "https://cache.garnix.io"
          "https://nix-community.cachix.org"
          "https://darknebula05.cachix.org"
        ];
        trusted-public-keys = [
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "darknebula05.cachix.org-1:DYYMiJaS92u6Iz/pXpuLlGqfqp4iR/WO535nBUnvxhU="
        ];
      };
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    };
  };
}
