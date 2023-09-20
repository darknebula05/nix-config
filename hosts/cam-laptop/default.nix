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

  # boot.loader = {
  #   efi = {
  #     canTouchEfiVariables = true;
  #     efiSysMountPoint = "/efi";
  #   };
  #   grub = {
  #     efiSupport = true;
  #     device = "nodev";
  #   };
  # };

  networking.hostName = "cam-laptop";

  networking.networkmanager.enable = true;

  system.stateVersion = "23.11";
}
