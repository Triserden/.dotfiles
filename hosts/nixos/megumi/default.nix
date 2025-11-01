{inputs, lib, pkgs, ...}:
let
  
  hostSpec = {
    hostname = "megumi";
    users = ["triserden"];
    primaryUser = "triserden";
    stateVersion = "25.05";
  };
in 
{
  inherit hostSpec;
  imports = lib.flatten [
    # --- Hardware ---
    inputs.hardware.nixosModules.lenovo-ideapad-15ach6
    ./hardware-configuration.nix
    
    # --- Disko ---
    inputs.disko.nixosModules.disko
    ./disk-config.nix

    # --- Optionals ---
    (map lib.custom.relativeToRoot [
      "hosts/common/optional/stylix.nix"
      "hosts/common/optional/hyprland.nix"
      "hosts/common/optional/clipboard.nix"
      #"hosts/common/optional/cursor.nix"
      "hosts/common/optional/idlelock.nix"
      "hosts/common/optional/pipewire.nix"
      "hosts/common/optional/udiskie.nix"
      "hosts/common/optional/wallpaper.nix"
    ])
    (map lib.custom.relativeToRoot ["hosts/common/core"])

  ];

  networking = {
    networkmanager.enable = true;
    enableIPv6 = true;
  };

  services.fwupd.enable = true;

  boot = {
    supportedFilesystems = ["ntrfs" "btrfs"];
    loader = {
      systemd-boot.enable = false;
        grub = {
          efiInstallAsRemovable = false;
          useOSProber = false;
          efiSupport = false;
          theme = lib.mkForce (pkgs.fetchFromGitHub {
                owner = "catppuccin";
                repo = "grub";
                rev = "3f62cd4174465631b40269a7c5631e5ee86dec45";
                sha256 = "d15FS7R78kdUKqC7EAei5Pe0Vuj2boVnm4WZYQdPURo=";
              } + "/catppuccin-grub-theme");
           extraEntries = 
           ''
              menuentry "Windows 11" {
                chainloader /efi/Windows/Boot/bootmgfw.efi
              }
            '';
          };
      };
  };

  system.stateVersion = hostSpec.stateVersion;
}
