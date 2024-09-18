{pkgs, config, lib, inputs, outputs, ...}:
{
  imports = [
    ./disk-config.nix
    ./impermanence.nix
  ];

  environment.systemPackages = [
    pkgs.jdk17
    pkgs.zellij
  ];

  # Setup sops-nix
  # Make docker secrets available
  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    defaultSopsFile = ./secrets.yaml;
    secrets = {
      freshrss_env = {
        path = "/home/triserden/services/rss/.env";
        owner="triserden";
      };
      traefik_env = {
        path = "/home/triserden/services/traefik/.env";
      };
    }; 
  };

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

  # Open minecraft port
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 25565 ];
    allowedUDPPorts = [ 25565 ];
  };

  
  ssh.enable = true;

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
  powerManagement.cpuFreqGovernor = "performance";
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
 
  # Home-manager
  home-manager.extraSpecialArgs = { inherit inputs outputs; };
  home-manager.users."triserden" = {
    imports = [./home-configuration.nix]; 
  };

  networking.useNetworkd = true;
  networking.hostId = "088fdbf6";
  networking.hostName = "futaba";
  nix.settings.experimental-features = [ "nix-command" "flakes"];
  system.stateVersion = "24.05";
}
