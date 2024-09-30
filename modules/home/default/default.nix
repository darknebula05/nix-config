{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  osConfig,
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

  config = {
    ${namespace} = mkIf cfg.enable {
      sh = mkDefault enabled;
      helix = mkDefault enabled;
      stylix = mkDefault enabled;
    };
    home.stateVersion = "24.05";
    fonts.fontconfig = enabled;
  };
}
