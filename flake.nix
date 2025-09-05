{
  description = "Triserden's v3 flake";

  outputs = { self, nixpkgs, ...}@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib;
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
          modules = [ ./hosts/nixos/${host} ];
          system = "x86_64-linux";
        };
      }) (builtins.attrNames (builtins.readDir ./hosts/nixos))
      );
    
    # TODO: Add unstable overlay
    # TODO: Add formatting and pre-commit validation
  };
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    hardware.url = "github:NixOS/nixos-hardware/master";
    secrets.url = "git+ssh://git@github.com:Triserden/.secrets.git/main";
  };

}
