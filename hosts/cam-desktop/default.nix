{ config, pkgs, ... }:

{
  imports = [
    ../../modules/system.nix

    ./hardware-configuration.nix
  ];

  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "23.11";
}
