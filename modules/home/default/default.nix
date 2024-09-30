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
      sh = enabled;
      helix = enabled;
      stylix = enabled;
    };
    home.stateVersion = "24.05";
    fonts.fontconfig = enabled;
  };
}
