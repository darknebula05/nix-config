# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, config, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "cam-laptop";
  networking.networkmanager.enable = true;
  networking.iproute2.enable = true;

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
    bluetooth.enable = true;
    graphics.enable = true;
  };

  users.defaultUserShell = pkgs.fish;
  users.users.${config.variables.username} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
    hashedPassword = "$6$kGHTJenH76uWjJqT$ElSPqGb2IZ8b7ybOYFAXLQIwYERSjSs.Ce4Vb5uOqLGP.C3m9CNGO03wMjemj5YEceX/92MjKdlKpZipvkxrP.";
  };

  programs = {
    dconf.enable = true;
    nm-applet.enable = true;
    steam.enable = true;
    virt-manager.enable = true;
  };

  virtualisation.libvirtd.enable = true;

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

  security.rtkit.enable = true;
  services = {
    blueman.enable = true;
    fwupd.enable = true;
    logrotate.checkConfig = false;
    openssh.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    printing.enable = true;
    tailscale.enable = true;
    tailscale.useRoutingFeatures = "both";
  };

  environment.variables = {
    POLKIT_BIN = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  };

  system.stateVersion = "24.05";
}
