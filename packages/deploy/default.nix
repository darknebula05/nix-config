{
  inputs,
  pkgs,
  writeText,
  ...
}:
let
  spec = {
    agents = builtins.mapAttrs (
      _: cfg: cfg.config.system.build.toplevel
    ) inputs.self.nixosConfigurations or { };
  };
in
(writeText "deploy.json" (builtins.toJSON spec))
