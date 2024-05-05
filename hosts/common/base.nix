{pkgs, commonModules, lib, config, ...}:

{
  imports = [
    commonModules.nixos.cli
    commonModules.nixos.git
    commonModules.nixos.tailscale
  ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # Set your time zone.
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
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.triserden = {
    isNormalUser = true;
    description = "Triserden";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    hashedPasswordFile = config.sops.secrets.triserden_password.path;
  };
  
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Add some useful tools
  programs.mtr.enable = true;
  environment.systemPackages = [
    pkgs.wget
    pkgs.ripgrep
  ];
  
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    openFirewall = lib.mkDefault false;
    settings.PasswordAuthentication = false;
  };
  
   
  system.stateVersion = "23.11"; # Did you read the comment?

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes"];
}
