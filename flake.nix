{
  description = "NixOS system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs =
    inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;
        snowfall.namespace = "camms";
      };
    in
    lib.mkFlake {
      systems = {
        modules.nixos = with inputs; [
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          impermanence.nixosModules.impermanence
        ];
        hosts = {
          cam-laptop.modules = with inputs; [
            nixos-hardware.nixosModules.framework-13-7040-amd
          ];
        };
      };
      home.modules = with inputs; [
        impermanence.nixosModules.home-manager.impermanence
      ];

      channels-config.allowUnfree = true;

    };
}
