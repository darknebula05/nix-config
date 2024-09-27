{ pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./nginx.nix
  ];
  hardware.graphics = {
    enable = true;
  };
  programs = {
    nix-ld.enable = true;
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
    avahi.enable = true;
    tailscale.enable = true;
    openssh.enable = true;
  };
}
