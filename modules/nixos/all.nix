{ flake, lib, ... }:
{
  imports = builtins.attrValues (lib.filterAttrs (n: _: n != "all") flake.nixosModules);
}
