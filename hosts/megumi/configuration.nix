{config, pkgs, inputs, outputs, ...}:
{
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix
  ];
  
  ## == General Applications ==
  programs = {
    firefox.enable = true;
    steam.enable = true;
    adb.enable = true;
  };
  environment.systemPackages = [
    pkgs.winetricks
    pkgs.wineWowPackages.waylandFull
    pkgs.prismlauncher
    pkgs.unstable.fastfetch
    pkgs.yt-dlp
    pkgs.vlc
    pkgs.btop
    pkgs.wget
    pkgs.pv
    pkgs.vesktop
    pkgs.android-studio
    pkgs.nix-output-monitor
    pkgs.unstable.packwiz
    pkgs.nvd
  ];
  

  ## == Sound ==
  # TODO: Might be an idea to move this to it's own module
  sound.enable = true;
  services = {
    pipewire = {
      enable = true;
      audio.enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
          support32Bit = true;
      };
    jack.enable = true;
    };
  };

  ## == Battery ==
  # TODO: Might be an idea to move this to it's own module
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
       governor = "schedutil";
       turbo = "never";
    };
    charger = {
       governor = "performance";
       turbo = "auto";
    };
  };

  ## == Locales ==
  # TODO: Might be an idea to move this to it's own module
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  ## == Bluetooth ==
  # TODO: Move to own module
  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;
    };
  };
  hardware.bluetooth.powerOnBoot = true;

  services.blueman.enable = true;


  ## == Modules ==
  # Setup sops-nix
  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    age.keyFile = "/var/lib/sops-nix/key.txt";
    age.generateKey = true;
  };

  # Enable user and pass password to module
  user.triserden = {
    enable = true;
    hashedPassword = "$y$j9T$vb8WZIoDWBwlr9n4R.gdu0$y3cuLPiuWbYYW.EoiBeMtuOu3vROywr9mxA5cg1BFuB";
  };

  docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  sops.secrets.tailscale_key = { };
  tailscale = {
    enable = true;
    authkey = config.sops.secrets.tailscale_key.path;
  };

  gui.enable = true;
  cli.enable = true;
  gpg.enable = true;
  git.enable = true;
  ssh.enable = true;
  unstable.enable = true;
  nvidia.enable = true;
  nwmanager.enable = true;
  printers.enable = true;

  sops.secrets.id_ed25519 = {
    owner = "triserden";
    mode = "600";
    path = "/home/triserden/.ssh/id_ed25519";
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
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes"];
  networking.hostName = "megumi";
  system.stateVersion = "24.05";
  home-manager.extraSpecialArgs = { inherit inputs outputs; };
  home-manager.users."triserden" = {
    imports = [
      ./home.nix
    ];    
  };
}

