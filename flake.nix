{

  nixConfig = {
    # substituers will be appended to the default substituters when fetching packages
    # nix com    extra-substituters = [munity's cache server
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };


  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    stylix = {
      url = "github:danth/stylix/release-24.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nix-alien.url = "github:thiagokokada/nix-alien";
    disko.url = "github:nix-community/disko";
    sops-nix.url = "github:Mic92/sops-nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { self, nixpkgs, stylix, sops-nix, home-manager, nix-alien, ... }@inputs: let
  inherit (self) outputs; 
  
  commonModules = {
    home = import ./modules/home-manager;
    nixos = import ./modules/nixos;
    common = import ./hosts/common;
  };


  in {
   
  add-unstable-packages = final: _prev: {
    unstable = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/05bbf675397d5366259409139039af8077d695ce.tar.gz";
        sha256 = "1r26vjqmzgphfnby5lkfihz6i3y70hq84bpkwd43qjjvgxkcyki0";
      }) {
        system = "x86_64-linux";
        config.allowUnfree = true;   
    };
  };
   
   nixosConfigurations.ayano = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs outputs commonModules; };
      modules = [
        ./hosts/ayano/configuration.nix
        sops-nix.nixosModules.sops
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        home-manager.nixosModules.home-manager
        {
          home-manager.sharedModules = [
            inputs.sops-nix.homeManagerModule
          ];
        }
      ];
    };
   
   nixosConfigurations.megumi = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs commonModules; };
      modules = [
        ./hosts/megumi/configuration.nix
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        stylix.nixosModules.stylix
        {
          home-manager.sharedModules = [
            inputs.sops-nix.homeManagerModule
            
          ];
        }
      ];
    };
    
    nixosConfigurations.bootstrapper = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs commonModules;};
      system = "x86_64-linux";
      modules = [
        ./hosts/bootstrapper/configuration.nix
        inputs.disko.nixosModules.disko
        inputs.home-manager.nixosModules.default
        sops-nix.nixosModules.sops
      ];
    };

    nixosConfigurations.izumi = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs commonModules;};
      system = "x86_64-linux";
      modules = [
        ./hosts/izumi/configuration.nix
        inputs.disko.nixosModules.disko
        inputs.home-manager.nixosModules.default
        sops-nix.nixosModules.sops
      ];
    };
  };
}
