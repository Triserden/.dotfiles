{config, lib, ...}:
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
  user.triserden = {
    enable = true;
    hashedPassword = "$y$j9T$tM7GLVR0bQVHJjd/VVQaU1$/foK/4wed6K7QSd5t65ey2t/dzpaSzDJ8.MsFbv.Zg3";
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
  
  ssh.enable = false;

  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    mirroredBoots = [
      { devices = [ "nodev"]; path = "/boot"; }
    ];

    ## VM testing
    devices = lib.mkForce [];
  };

  # Hetzner Online specific config
  systemd.network = {
    enable = true;
    networks.default = {
      name = "en01"; # The name of the interface
      DHCP = "ipv4";
      address = [ 
        "2a01:4f8:110:31cb::/64"
      ];
      gateway = [ "fe80::1" ];
      linkConfig.RequiredForOnline = "routable";
    };
  };
 
  networking.useNetworkd = true;
  networking.hostId = "088fdbf6";
  networking.hostName = "futaba";
  nix.settings.experimental-features = [ "nix-command" "flakes"];
  system.stateVersion = "24.05";
}
