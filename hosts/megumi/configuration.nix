# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ commonModules, inputs, outputs, config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./btrfs-disk-config.nix
      inputs.disko.nixosModules.disko
      commonModules.nixos.hyprland
      commonModules.nixos.nwmanager
      commonModules.nixos.firefox
      commonModules.nixos.gpg
      commonModules.nixos.cli
      commonModules.nixos.git
      commonModules.nixos.ssh
      commonModules.nixos.amsterdam
      commonModules.nixos.cachix
      commonModules.nixos.stylix
      commonModules.nixos.utils
      commonModules.nixos.tailscale
      commonModules.nixos.nvidia
      commonModules.nixos.pipewire
      commonModules.nixos.nemo
      commonModules.nixos.waybar
      commonModules.nixos.docker
      commonModules.nixos.bluetooth
      commonModules.nixos.games
];


  environment.systemPackages = [
    inputs.nix-alien.packages.x86_64-linux.nix-alien
    pkgs.nss_latest.dev
    pkgs.nss_latest
    pkgs.glfw
    pkgs.jetbrains.webstorm
    pkgs.python313
    pkgs.nvd
    pkgs.unstable.beekeeper-studio 
    pkgs.unstable.obsidian
    pkgs.ffmpeg_5-full
    pkgs.yt-dlp
    pkgs.vlc
    pkgs.libvlc
    pkgs.unstable.nodePackages.pnpm
    pkgs.brightnessctl
    pkgs.btop
    pkgs.distrobox
  ];

  nixpkgs.config.permittedInsecurePackages = [
  ];

  networking.firewall.allowedTCPPorts = [7236 7250];
  networking.firewall.allowedUDPPorts = [7236 5353];


  programs.nix-ld.enable = true;

  # Sets up all the libraries to load
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    nss.dev
    openssl
    curl
    expat
    # ...
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
    extraGroups = [ "inputs" "networkmanager" "wheel" "docker" ];
    hashedPassword = "$y$j9T$MTzUZh4e5BCre7KQ0nzyS1$XerRKkLOByi6u3BUQ2WerOym2MIc2pv.YuXUwWLc519";
  };

  boot.loader.grub = {
    useOSProber = true;
    efiSupport = true;
    extraEntries = 
      ''
        menuentry "Windows 11" {
          chainloader /efi/Windows/Boot/bootmgfw.efi
        }
      '';
  };  
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.supportedFilesystems = ["ntfs" "btrfs"];
  networking.hostName = "megumi"; # Define your hostname.

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    outputs.add-unstable-packages
  ];
  system.stateVersion = "23.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes"];
  
  home-manager.extraSpecialArgs = { inherit inputs outputs commonModules; };
  home-manager.users."triserden" = {
    imports = [./home.nix];    
  };
}
