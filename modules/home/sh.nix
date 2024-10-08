{
  flake,
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.sh;
in
with lib;
with flake.lib;
{
  imports = [ inputs.nix-index-database.hmModules.nix-index ];

  options.camms.sh.enable = mkEnableOption "sh";

  config = mkIf cfg.enable {
    camms.lf = enabled;

    home.packages = with pkgs; [
      cachix
      compsize
      dust
      entr
      eza
      fd
      nix-tree
      ripdrag
      socat
      spotify-player
      texliveSmall
      unzip
    ];

    programs = {
      bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [
          batdiff
          batman
        ];
      };
      btop = {
        enable = true;
        settings.vim_keys = true;
      };
      direnv = {
        enable = true;
        nix-direnv = enabled;
      };
      fish = {
        enable = true;
        functions = {
          gi = ''${pkgs.curl}/bin/curl -sL https://www.toptal.com/developers/gitignore/api/$argv'';
          ts-exit = ''
            tailscale status --peers --json | nix run nixpkgs#jq -- '.ExitNodeStatus.ID as $node_id | .Peer[] | select(.ID==$node_id) | .HostName'
          '';
        };
        shellAliases = {
          diff = "batdiff";
          ls = "eza";
          man = "batman";
          za = "zellij a -c";
        };
      };
      fzf = enabled;
      git = {
        enable = true;
        delta = enabled;
        userName = "darknebula05";
        userEmail = "camms205@aol.com";
        extraConfig = {
          init.defaultBranch = "main";
        };
      };
      lazygit = enabled;
      man.generateCaches = true;
      nix-index = enabled;
      nix-index-database.comma = enabled;
      pandoc = enabled;
      ripgrep = enabled;
      starship = enabled;
      yazi = {
        enable = true;
        enableFishIntegration = true;
      };
      zellij = {
        enable = true;
        settings = {
          pane_frames = false;
        };
      };
      zoxide = enabled;
    };
  };
}
