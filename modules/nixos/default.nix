{
  # Core modules
  nwmanager = import ./nwmanager.nix; 
  hyprland = import ./hyprland.nix;
  firefox = import ./firefox.nix;
  gpg = import ./gpg.nix;
  git = import ./git.nix;
  tailscale = import ./tailscale.nix;
  cachix = import ./cachix.nix;
  ssh = import ./ssh.nix;
  nvidia = import ./nvidia.nix;
  pipewire = import ./pipewire.nix;
  nemo = import ./nemo.nix;
  waybar = import ./waybar.nix;
  stylix = import ./stylix.nix;

  # Locales
  amsterdam = import ./amsterdam.nix;

  # CLI stuff
  cli = import ./cli.nix;
  utils = import ./utils.nix;

  # Other apps
  hledger = ./hledger.nix;
  docker = ./docker.nix;
  
}
