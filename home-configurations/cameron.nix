{ ezModules, lib, ... }:
{
  imports = lib.attrValues {
    inherit (ezModules) hyprland programs browser;
  };
}
