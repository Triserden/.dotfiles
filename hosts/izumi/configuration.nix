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

  networking.hostName = "izumi"; # Define your hostname.
  
  home-manager = {
    extraSpecialArgs = { inherit inputs outputs commonModules; };
    users."triserden".imports = [ ./home.nix ];
  };

}
