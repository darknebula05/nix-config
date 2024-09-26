{
  description = "NixOS system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    ez-config.url = "github:ehllie/ez-configs";
    ez-config.inputs = {
      nixpkgs.follows = "nixpkgs";
      flake-parts.follows = "flake-parts";
    };

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    stylix.inputs = {
      home-manager.follows = "home-manager";
      nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit self inputs; } {
      imports = [ inputs.ez-config.flakeModule ];
      debug = true;
      ezConfigs = {
        root = ./.;
        globalArgs = {
          inherit inputs;
        };
        nixos.hosts = {
          cam-desktop.userHomeModules = [ "cameron" ];
          cam-laptop.userHomeModules = [ "cameron" ];
          nixos-wsl.userHomeModules = [ "cshearer" ];
        };
      };
      systems = [ "x86_64-linux" ];
      perSystem =
        { pkgs, ... }:
        let
          toplevel = builtins.mapAttrs (_: cfg: cfg.config.system.build.toplevel) self.nixosConfigurations;
          spec = {
            agents = toplevel;
          };
          deploy = pkgs.writeText "cachix-deploy.json" (builtins.toJSON spec);
        in
        {
          packages = toplevel // {
            inherit deploy;
            default = deploy;
          };
        };
    };
}
