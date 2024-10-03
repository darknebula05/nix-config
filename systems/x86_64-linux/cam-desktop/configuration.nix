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
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot = enabled;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [
    "btrfs"
    "zfs"
  ];
  boot.zfs.forceImportRoot = false;

  fileSystems = {
    "/".options = [ "compress-force=zstd" ];
    "/home".options = [ "compress-force=zstd" ];
    "/nix".options = [
      "compress-force=zstd"
      "noatime"
    ];
  };

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

  users.defaultUserShell = pkgs.fish;
  users.users.${config.${namespace}.variables.username} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "docker"
      "dialout"
    ];
    hashedPassword = "$6$kGHTJenH76uWjJqT$ElSPqGb2IZ8b7ybOYFAXLQIwYERSjSs.Ce4Vb5uOqLGP.C3m9CNGO03wMjemj5YEceX/92MjKdlKpZipvkxrP.";
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
    docker = {
      enable = true;
    };
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
    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };
  };

  environment.variables = {
    POLKIT_BIN = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  };

  system.stateVersion = "24.05";
}
