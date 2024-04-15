# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ commonModules, inputs, outputs, ... }:

{
  imports =
    [
      commonModules.common.base
    ];

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  networking.hostName = "littlecreek"; # Define your hostname.
  

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs commonModules; };
    users."triserden".imports = [ ./home.nix ];
  };

}
