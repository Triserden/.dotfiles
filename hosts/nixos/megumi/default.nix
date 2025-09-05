{inputs, lib, pkgs, ...}:
{
  imports = lib.flatten [
    # --- Hardware ---
    inputs.hardware.nixosModules.lenovo-ideapad-15ach6
    ./hardware-configuration.nix
    
    # --- Disko ---
    inputs.disko.nixosModules.disko
    ./disk-config.nix


    (map lib.custom.relativeToRoot ["hosts/common/core"])

  ];

  hostSpec = {
    hostname = "megumi";
  };

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
          efiInstallAsRemovable = true;
          useOSProber = true;
          efiSupport = true;
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

  system.stateVersion = "25.05";
}
