{ pkgs, osConfig, ... }:

{
  home.username = "${osConfig.variables.username}";
  home.homeDirectory = "/home/${osConfig.variables.username}";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    ranger
    nil
    swaybg
  ];

  stylix.image = ./mandalorian.jpg;
  stylix.polarity = "dark";

  programs = {
    starship.enable = true;
    tmux.enable = true;
    helix.enable = true;
    kitty.enable = true;
    feh.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };
      bind = [
        "CTRL ALT,DELETE,exit,"
        "ALT,Q,exec,kitty"
        "ALT,1,workspace,1"
        "ALT,2,workspace,2"
        "ALT,3,workspace,3"
        "ALT,4,workspace,4"
        "ALT,5,workspace,5"
      ];
      exec-once = [ "swaybg -i ~/.dotfiles/mandalorian.jpg" ];
    };
  };

  home.sessionVariables = {
    EDITOR = "hx";
  };

  programs.home-manager.enable = true;
}
