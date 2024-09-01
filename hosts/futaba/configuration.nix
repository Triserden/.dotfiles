{config, ...}:
{
  imports = [
    ./disk-config.nix
    ./impermanence.nix
  ];

  # Setup sops-nix
  sops.defaultSopsFile = ./secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  ## === User ===
  # Enable user and pass password to module
  sops.secrets.triserden_futaba_password.neededForUsers = true;
  user.triserden = {
    enable = true;
    hashedPasswordFile = config.sops.secrets.triserden_futaba_password.path;
  };


  sops.secrets.tailscale_key = { };
  ## === Config ===

  docker = {
    enable = true;
    storageDriver = "zfs";
  };

  tailscale = {
    enable = true;
    authkey = config.sops.secrets.tailscale_key.path;
  };

  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    mirroredBoots = [
      { devices = [ "nodev"]; path = "/boot"; }
    ];
  };

  # Hetzner Online specific config
  systemd.network = {
    enable = true;
    networks.default = {
      name = "en01"; # The name of the interface
      DHCP = "ipv4";
      addresses = [ 
        {
          # Replace the address with the one assigned to your machine
          Address = "2a01:4f8:110:31cb::/64"; 
        }
      ];
      gateway = [ "fe80::1" ];
      linkConfig.RequiredForOnline = "routable";
    };
  };
  
  networking.hostId = "088fdbf6";
  networking.hostName = "futaba";
  system.stateVersion = "24.05";
}
