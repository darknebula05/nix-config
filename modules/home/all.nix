{ flake, ... }:
{
  imports = builtins.attrValues (builtins.removeAttrs flake.homeModules [ "all" ]);
}
