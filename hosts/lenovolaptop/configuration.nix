# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ commonModules, inputs, outputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      commonModules.common.base
      commonModules.nixos.hyprland
      commonModules.nixos.nwmanager
      commonModules.nixos.firefox
      commonModules.nixos.gpg
      # commonModules.nixos.alacritty 
];

  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "lenovolaptop"; # Define your hostname.

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs commonModules; };
    users."triserden".imports = [./home.nix];

  };
}
