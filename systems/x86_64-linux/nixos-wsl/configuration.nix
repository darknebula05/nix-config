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
    ./nginx.nix
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
      "docker"
    ];
    isNormalUser = true;
  };

  fonts.packages = with pkgs; [ fira-code-nerdfont ];

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  services = {
    avahi = enabled;
    tailscale = enabled;
    openssh = enabled;
  };
}
