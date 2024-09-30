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
  boot.kernelPackages = pkgs.linuxPackages_latest;

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

  users.defaultUserShell = pkgs.fish;
  users.users.${config.${namespace}.variables.username} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
    hashedPassword = "$6$kGHTJenH76uWjJqT$ElSPqGb2IZ8b7ybOYFAXLQIwYERSjSs.Ce4Vb5uOqLGP.C3m9CNGO03wMjemj5YEceX/92MjKdlKpZipvkxrP.";
  };

  programs = {
    dconf = enabled;
    nm-applet = enabled;
    steam = enabled;
    virt-manager = enabled;
  };

  virtualisation.libvirtd = enabled;

  environment.systemPackages = with pkgs; [
    brightnessctl
    adwaita-icon-theme
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
