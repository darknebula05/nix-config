{
  description = "NixOS system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    ez-configs.url = "github:ehllie/ez-configs";
    ez-configs.inputs.flake-parts.follows = "flake-parts";
    ez-configs.inputs.nixpkgs.follows = "nixpkgs";

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs = {
      home-manager.follows = "home-manager";
      nixpkgs.follows = "nixpkgs";
    };

    poetry2nix.url = "github:nix-community/poetry2nix";
    poetry2nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.ez-configs.flakeModule ];

      debug = true;
      ezConfigs = {
        root = ./.;
        globalArgs = {
          inherit inputs;
        };
        nixos = {
          configurationsDirectory = ./configs/nixos;
          modulesDirectory = ./modules/nixos;
          hosts = {
            cam-desktop.userHomeModules = [ "cameron" ];
            cam-laptop.userHomeModules = [ "cameron" ];
            nixos-wsl.userHomeModules = [ "cshearer" ];
          };
        };
        home = {
          configurationsDirectory = ./configs/home;
          modulesDirectory = ./modules/home;
        };
      };

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        { system, pkgs, ... }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.poetry2nix.overlays.default
            ];
          };
          packages = {
            riven = pkgs.callPackage ./packages/riven.nix { };
            riven-frontend = pkgs.callPackage ./packages/riven-frontend.nix { };
            zurg = pkgs.callPackage ./packages/zurg.nix { };
          };
        };
    };
}
