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
      tailscale_subnet_env = {
        path = "/home/triserden/services/tailscale-subnet/.env";
        owner="triserden";
      };
      freshrss_env = {
        path = "/home/triserden/services/rss/.env";
        owner="triserden";
      };
      traefik-ext_env = {
        path = "/home/triserden/services/traefik-ext/.env";
      };
      traefik_env = {
        path = "/home/triserden/services/traefik/.env";
      };
      firefly3_env = {
        path = "/home/triserden/services/firefly3/.env";
      };
      firefly3_db_env = {
        path = "/home/triserden/services/firefly3/.db.env";
      };
      firefly3_importer_env = {
        path = "/home/triserden/services/firefly3/.importer.env";
      };
      monitoring_env = {
        path = "/home/triserden/services/monitoring/.env";
        owner="triserden";
      };
      pihole_env = {
        path = "/home/triserden/services/pihole/.env";
        owner="triserden";
      };
      fah_env = {
        path = "/home/triserden/services/foldingathome/.env";
        owner="triserden";
      };
      pterodactyl_mariadb_config = {
        sopsFile = ./secrets/pterodactyl_mariadb_config.env;
        format = "dotenv";
        path = "/home/triserden/services/pterodactyl/conf.d/mariadb.env";
        owner="triserden";
        key = "";
      };
      pterodactyl_panel_config = {
        sopsFile = ./secrets/pterodactyl_panel_config.env;
        format = "dotenv";
        path = "/home/triserden/services/pterodactyl/conf.d/panel.env";
        owner="triserden";
        key = "";
      };
      pterodactyl_wing_config = {
        sopsFile = ./secrets/pterodactyl_wing_config.yaml;
        format = "yaml";
        path = "/home/triserden/services/pterodactyl/conf.d/daemon/config.yml";
        owner="triserden";
        key = "";
      };
      hlr_env = {
        sopsFile = ./hlrconfig.yaml;
        format = "yaml";
        path = "/home/triserden/services/hlr/config.yaml";
        owner="triserden";
        key = "";
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
    allowedTCPPorts = [ 25565 8443 8081 2023 ];
    allowedUDPPorts = [ 25565 8443 8081 2023 ];
  };

  networking.hosts = {
  "78.46.38.222" = ["pterodactyl.triserden.dev" "node1.pterodactyl.triserden.dev"];
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
  home-manager = { 
    backupFileExtension = ".BAK";
    extraSpecialArgs = { inherit inputs outputs; };
    users."triserden" = {
      imports = [./home-configuration.nix]; 
    };
  };

  
  networking.useNetworkd = true;
  networking.hostId = "088fdbf6";
  networking.hostName = "futaba";
  nix.settings.experimental-features = [ "nix-command" "flakes"];
  system.stateVersion = "24.11";
}
