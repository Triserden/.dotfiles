# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, commonModules, inputs, outputs, lib, modulesPath, ... }:

{
  imports =
    [
      commonModules.common.base
      (modulesPath+"/profiles/qemu-guest.nix")
      (modulesPath + "/installer/scan/not-detected.nix")
      ./disk-config.nix
    ];
  
  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets.triserden_password = {
     sopsFile = ./secrets.yaml;
     neededForUsers = true;
  };

  users.users.triserden = {
    isNormalUser = true;
    description = "Triserden";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    hashedPassword = "$y$j9T$MTzUZh4e5BCre7KQ0nzyS1$XerRKkLOByi6u3BUQ2WerOym2MIc2pv.YuXUwWLc519";
  };
  
  services.openssh.openFirewall = lib.mkForce true;

  networking.hostName = "izumi"; # Define your hostname.
  
  home-manager = {
    extraSpecialArgs = { inherit inputs outputs commonModules; };
    users."triserden".imports = [ ./home.nix ];
  };

}
