{
  flake,
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
with lib;
with flake.lib;
let
  user = "cameron";
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    flake.nixosModules.all
  ];

  camms = {
    archetypes.workstation = enabled;
    home.path = ./home.nix;
    user.extraGroups = [
      "networkmanager"
      "libvirtd"
    ];
    variables = {
      username = "${user}";
      flakeDir = "/home/cameron/dotfiles/nix";
    };
  };

  boot = {
    loader.systemd-boot = enabled;
    loader.efi.canTouchEfiVariables = true;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

  networking.hostName = "cam-laptop";
  networking.networkmanager = enabled;
  networking.iproute2 = enabled;

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  time.timeZone = "America/New_York";
  hardware = {
    bluetooth = enabled;
    graphics = enabled;
  };

  programs = {
    dconf = enabled;
    nm-applet = enabled;
    steam = enabled;
    virt-manager = enabled;
  };

  virtualisation.libvirtd = enabled;

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    brightnessctl
    git
    helvum
    iproute2
    socat
    sshfs
    vim
    wget
    xfce.xfce4-icon-theme
  ];
  fonts.packages = with pkgs; [
    corefonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code-nerdfont
  ];

  security.rtkit = enabled;
  services = {
    blueman = enabled;
    fwupd = enabled;
    logrotate.checkConfig = false;
    openssh = enabled;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse = enabled;
      jack = enabled;
    };
    printing = enabled;
  };

  environment.variables = {
    POLKIT_BIN = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  };

  system.stateVersion = "24.05";
}
