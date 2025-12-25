{
  description = "Triserden's v3 flake";

  outputs = { self, nixpkgs, ...}@inputs:
    let
      inherit (self) outputs;
            lib = nixpkgs.lib.extend (self: super: { custom = import ./lib { inherit (nixpkgs) lib; }; });
    in 
    {
    


    nixosConfigurations = builtins.listToAttrs (
        map (host: {
          name = host;
          value = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs outputs lib;
              isDarwin = false;
            };
            system = "x86_64-linux";
            modules = [
              ./hosts/nixos/${host}
            ];

          };
        }) (builtins.attrNames (builtins.readDir ./hosts/nixos))
      );

    # TODO: Add unstable overlay
    # TODO: Add formatting and pre-commit validation
  };
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";

    hardware.url = "github:NixOS/nixos-hardware/master";

    secrets.url = "git+ssh://git@github.com/triserden/.secrets?ref=main";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Secrets management.
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Theming
    stylix.url = "github:danth/stylix/release-25.05";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    # Nvim
    nixvim = {
    url = "github:nix-community/nixvim";
  };
    Neve.url = "github:triserden/Neve/";

    swww.url = "github:LGFae/swww/a2864804e48533f4c70c63930d8cb24b394288ec";

    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
  };

}
