# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ commonModules, inputs, outputs, config, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./btrfs-disk-config.nix
      commonModules.nixos.hyprland
      commonModules.nixos.nwmanager
      commonModules.nixos.firefox
      commonModules.nixos.gpg
      commonModules.nixos.cli
      commonModules.nixos.git
      commonModules.nixos.ssh
      commonModules.nixos.amsterdam
      commonModules.nixos.cachix
      commonModules.nixos.fonts
      commonModules.nixos.utils
      commonModules.nixos.tailscale
      commonModules.nixos.hledger
      commonModules.nixos.nvidia
      commonModules.nixos.pipewire
];

  sops.defaultSopsFile = ./secrets.yaml;
 
  sops.secrets.id_ed25519 = {
    sopsFile = ./id_ed25519;
    mode = "6600";
    owner = config.users.users.triserden.name;
    format = "binary";
    path = "/home/triserden/.ssh/id_ed25519";
  };
  
  users.users.triserden = {
    isNormalUser = true;
    description = "Triserden";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    hashedPassword = "$y$j9T$MTzUZh4e5BCre7KQ0nzyS1$XerRKkLOByi6u3BUQ2WerOym2MIc2pv.YuXUwWLc519";
  };

  boot.loader.grub = {
    device = "/dev/vda";
    useOSProber = true;
    efiSupport = true;
  };

  networking.hostName = "megumi"; # Define your hostname.

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [outputs.add-unstable-packages];
  system.stateVersion = "23.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes"];
  
  home-manager.extraSpecialArgs = { inherit inputs outputs commonModules; };
  home-manager.users."triserden" = {
    imports = [./home.nix];    
  };
}
