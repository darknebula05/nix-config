{
  inputs,
  pkgs,
  config,
  ezModules,
  ...
}:

{
  imports = with inputs; [
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
    stylix.nixosModules.stylix
    ezModules.variables
    ezModules.cachix
  ];

  variables = {
    username = "cameron";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  services.openssh.enable = true;
  services.qemuGuest.enable = true;

  security.sudo.wheelNeedsPassword = false;

  users.defaultUserShell = pkgs.fish;

  programs = {
    hyprland.enable = true;
    fish.enable = true;
  };
  stylix.image = ./mandalorian.jpg;
  stylix.polarity = "dark";
  stylix.targets = {
    console.enable = false;
  };

  users.users.${config.variables.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "pw123";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${config.variables.username} = import ./home.nix;
    extraSpecialArgs = {
      inherit inputs;
      inherit (config.variables) username;
    };
  };
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    helix
  ];

  networking.firewall.enable = false;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "23.11";
}
