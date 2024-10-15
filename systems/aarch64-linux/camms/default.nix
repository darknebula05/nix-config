{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace};
{
  imports = [
    ./disko.nix
  ];

  facter.reportPath = ./facter.json;
  fileSystems."/nix/persist".neededForBoot = true;

  ${namespace} = {
    archetypes.server = enabled;
    facter = {
      enable = true;
      path = ./facter.json;
    };
    home = enabled;
    impermanence = enabled;
    variables.username = "cameron";
  };

  networking = {
    hostName = "${namespace}";
    hostId = "707378ff";
  };

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh = enabled;

  environment.systemPackages = with pkgs; [
    curl
    vim
  ];
  documentation.man.generateCaches = false;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOTr+IuOrJF+tNJHjwHaNTMnV1PwbvuO+Z1XeXXIETeq cshearer@nixos-wsl"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJMumZUYRobSetz6wCJAIxryfbTUNf6fnGZU8P5RCcsW cameron@cam-desktop"
  ];

  system.stateVersion = "24.05";
}
