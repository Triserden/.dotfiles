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

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { self, nixpkgs, ... }@inputs: let
  inherit (self) outputs; 
  commonModules = {
    home = import ./modules/home-manager;
    nixos = import ./modules/nixos;
    common = import ./hosts/common;
  };
 
  in {

    nixosConfigurations.lenovolaptop = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs commonModules; };
      modules = [
        ./hosts/lenovolaptop/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };
    
    # nixosConfigurations.littlecreek = nixpkgs.lib.nixosSystem {
      # specialArgs = {inherit inputs outputs;};
      # modules = [
        # ./hosts/littlecreek/configuration.nix
        # inputs.home-manager.nixosModules.default
      # ];
    # };
  };
}
