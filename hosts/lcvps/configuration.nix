# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ commonModules, inputs, outputs, lib, modulesPath, ... }:

{
  imports =
    [
      commonModules.common.base
      (modulesPath+"/profiles/qemu-guest.nix")
      (modulesPath + "/installer/scan/not-detected.nix")
      ./disk-config.nix
    ];

  services.openssh.openFirewall = lib.mkForce true;

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  networking.hostName = "lcvps"; # Define your hostname.
  

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs commonModules; };
    users."triserden".imports = [ ./home.nix ];
  };

}
