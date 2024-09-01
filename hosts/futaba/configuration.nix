{sops, config, pkgs}:
{
  imports = [
    ./disk-config.nix
    ./impermanence.nix
  ];

  # Setup sops-nix
  sops.defaultSopsFile = ./secrets.yaml;

  ## === User ===
  # Enable user and pass password to module
  sops.secrets.triserden_futaba_password.neededForUsers = true;
  user.triserden = {
    enable = true;
    hashedPasswordFile = config.sops.secrets.triserden_yuki_password.path;
  };


  ## === Config ===
  docker = {
    enable = true;
    storageDriver = "zfs";
  };

  sops.secrets.tailscale_key = {};
  tailscale = {
    enable = true;
    keyfile = config.sops.secrets.tailscale_key;
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
}
