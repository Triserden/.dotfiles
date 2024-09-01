{
  description = "Triserden's NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    stylix.url = "github:danth/stylix/release-24.05";
  };

  outputs =
    { self, nixpkgs, nixpkgs-unstable, ... }@inputs:
    {
      
      # Megumi (Lenovo Ideapad Gaming 3)
      nixosConfigurations.yuki = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        
        specialArgs = {
          pkgs.unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };

        modules = [ 
          "./hosts/yuki/configuration.nix"
          "./modules"
          inputs.sops-nix.nixosModules.sops
          inputs.stylix.nixosModules.stylix


          inputs.home-manager.nixosModules.home-manager
          # Add sops-nix home manager module
          {
            home-manager.sharedModules = [
              inputs.sops-nix.homeManagerModules.sops
            ];
          }
        ];
      };
      

      # Futaba (Hetzner Dedicated Box)
      nixosConfigurations.futaba = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        
        specialArgs = {
          pkgs.unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };

        modules = [ 
          "./hosts/futaba/configuration.nix"
          "./modules"
          inputs.sops-nix.nixosModules.sops
          inputs.stylix.nixosModules.stylix


          inputs.home-manager.nixosModules.home-manager
          # Add sops-nix home manager module
          {
            home-manager.sharedModules = [
              inputs.sops-nix.homeManagerModules.sops
            ];
          }
        ];
      };
    };
}
