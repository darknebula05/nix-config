{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace};
{
  imports = [
    ./hardware-configuration.nix
    # ./nginx.nix
  ];
  hardware.graphics = {
    enable = true;
  };
  programs = {
    nix-ld = enabled;
  };

  networking.hostName = "nixos-wsl";
  users.defaultUserShell = pkgs.fish;
  users.users.cshearer = {
    extraGroups = [
      "wheel"
    ];
    isNormalUser = true;
  };

  fonts.packages = with pkgs; [ fira-code-nerdfont ];

  services = {
    avahi = enabled;
    openssh = enabled;
  };
}
