{config, ...}:
{
  imports = [
    ./disk-config.nix
  ];

  # Setup sops-nix
  sops.defaultSopsFile = ./secrets.yaml;
  sops.age.keyFile = /etc/ssh/ssh_host_ed25519_key;

  # Enable user and pass password to module
  user.triserden = {
    enable = true;
    hashedPassword = "$y$j9T$3O1atJXszc0vlBAzBEby00$YPWEJlb6clsGgTa4xy.x0lhMQTF53pGZQyNzAUd8jKD";
  };

  docker = {
    enable = true;
    storageDriver = "zfs";
  };

  tailscale = {
    enable = true;
    authkey = config.sops.secrets.tailscale_key.path;
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
  
  nix.settings.experimental-features = [ "nix-command" "flakes"];
  networking.hostName = "yuki";
  system.stateVersion = "24.05";
}
