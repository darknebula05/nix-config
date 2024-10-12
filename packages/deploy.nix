{ flake, pkgs, ... }:
let
  spec = {
    agents = builtins.mapAttrs (_: cfg: cfg.config.system.build.toplevel) flake.nixosConfigurations;
  };
in
(pkgs.writeText "deploy.json" (builtins.toJSON spec))
