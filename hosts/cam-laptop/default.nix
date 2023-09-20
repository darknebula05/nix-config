{ config, pkgs, ... }:

{
  imports = [
    ../../modules/system.nix

    ./hardware-configuration.nix
  ];

  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "cam-laptop";

  networking.networkmanager.enable = true;

  system.stateVersion = "23.11";
}
