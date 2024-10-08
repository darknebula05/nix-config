{ flake, ... }:
{
  imports = builtins.attrValues (builtins.removeAttrs flake.nixosModules [ "all" ]);
}
