{
  description = "Triserden's NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    impermanence.url = "github:nix-community/impermanence";
    #stylix.url = "github:danth/stylix/release-24.05";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, nixpkgs-unstable, sops-nix, disko, impermanence, ... }@inputs:
    {
      
      # Megumi (Lenovo Ideapad Gaming 3)
      nixosConfigurations.megumi = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        
        specialArgs = {
          inherit inputs;
          #pkgs.unstable = import nixpkgs-unstable {
          #  inherit system;
          #  config.allowUnfree = true;
          #};
        };

        modules = [ 
          ./hosts/megumi/configuration.nix
          ./modules/nixos
          inputs.sops-nix.nixosModules.sops
          #inputs.stylix.nixosModules.stylix
          disko.nixosModules.disko


          inputs.home-manager.nixosModules.home-manager
          # Add sops-nix home manager module
          {
            home-manager.sharedModules = [
              inputs.sops-nix.homeManagerModules.sops
              ./modules/home
            ];
          }
        ];
      };
      

      # Futaba (Hetzner Dedicated Box)
      nixosConfigurations.futaba = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        
        specialArgs = {
          inherit inputs;
          #pkgs.unstable = import nixpkgs-unstable {
          #  inherit system;
          #  config.allowUnfree = true;
        };

        modules = [ 
          ./hosts/futaba/configuration.nix
          ./modules/nixos
          impermanence.nixosModules.impermanence
          inputs.sops-nix.nixosModules.sops
          #inputs.stylix.nixosModules.stylix
          disko.nixosModules.disko

          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.sharedModules = [
              inputs.sops-nix.homeManagerModules.sops
              ./modules/home
            ];
          }
        ];
      };
    };
}
