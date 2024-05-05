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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    disko.url = "github:nix-community/disko";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
  };


  outputs = { self, nixpkgs, sops-nix, ... }@inputs: let
  inherit (self) outputs; 
  commonModules = {
    home = import ./modules/home-manager;
    nixos = import ./modules/nixos;
    common = import ./hosts/common;
  };
 
  in {
    nixosConfigurations.megumi = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs commonModules; };
      modules = [
        ./hosts/megumi/configuration.nix
        inputs.home-manager.nixosModules.default
        sops-nix.nixosModules.sops
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
