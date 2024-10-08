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
    ./disko.nix
    flake.nixosModules.all
  ];

  facter.reportPath = ./facter.json;

  camms = {
    facter = {
      enable = true;
      path = ./facter.json;
    };
    home.path = ./home.nix;
    archetypes.workstation = enabled;
    services.arrs = enabled;
    user.extraGroups = [
      "networkmanager"
      "libvirtd"
      "dialout"
    ];
    variables = {
      username = "${user}";
      flakeDir = "/home/cameron/.dotfiles/nix";
    };
  };

  boot = {
    loader.systemd-boot = enabled;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = [
      "btrfs"
      "zfs"
    ];
    zfs.forceImportRoot = false;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

  networking = {
    hostName = "cam-desktop";
    hostId = "ed222780";
    networkmanager = {
      enable = true;
      unmanaged = [ "interface-name:ve-*" ];
    };
    iproute2 = enabled;
    nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = "enp14s0";
    };
  };

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
    coolercontrol = enabled;
    gnome-terminal = enabled;
    dconf = enabled;
    nm-applet = enabled;
    steam = enabled;
    virt-manager = enabled;
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm = enabled;
      };
    };
    containers = enabled;
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    dive
    distrobox
    adwaita-icon-theme
    helvum
    iproute2
    podman-compose
    podman-tui
    socat
    sshfs
    vim
    virtiofsd
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
    avahi = enabled;
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
    ratbagd = enabled;
    sunshine = {
      enable = true;
      capSysAdmin = true;
    };
  };

  environment.variables = {
    POLKIT_BIN = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  };

  system.stateVersion = "24.05";
}
