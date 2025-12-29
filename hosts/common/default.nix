{ inputs, config, ... }: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager

    ./tailscale.nix
    ./hostconfig.nix
    ./sops.nix
    ./ssh.nix
  ];
  # TODO: Set tailscale, SOPS, default programs

  # Default programs
  # wget, unzip, dig?, tree, term multiplexer (term?), nvim, screen, nnn, pueue, eza, fzf?, git, fonts, btop, A

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "bk";
    users."${config.host.user}".home.stateVersion = config.host.stateVersion;
  };

  system = { stateVersion = config.host.stateVersion; };

  nix.settings = {
    min-free = 250000000;
    max-free = 1000000000;
    trusted-users = [ "@wheel" ];
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  # Run garbage-collection weekly
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  networking = {
    hostName = config.host.hostname;
    hostId = config.host.hostId;
    firewall.enable = true;
  };
}
