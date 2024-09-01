{config, ...}:
{
  imports = [
    ./disk-config.nix
  ];

  # Setup sops-nix
  sops.defaultSopsFile = ./secrets.yaml;
  sops.age.keyFile = /etc/ssh/ssh_host_ed25519_key;

  # Enable user and pass password to module
  sops.secrets.triserden_yuki_password.neededForUsers = true;
  user.triserden = {
    enable = true;
    hashedPasswordFile = config.sops.secrets.triserden_yuki_password.path;
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
  
  networking.hostName = "yuki";
  system.stateVersion = "24.05";
}
