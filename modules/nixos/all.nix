{ flake, ... }:
{
  imports = builtins.removeAttrs flake.nixosModules [ "all" ];
}
