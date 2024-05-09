{
  # Core modules
  nwmanager = import ./nwmanager.nix; 
  hyprland = import ./hyprland.nix;
  firefox = import ./firefox.nix;
  gpg = import ./gpg.nix;
  git = import ./git.nix;
  tailscale = import ./tailscale.nix;
  cachix = import ./cachix.nix;
  fonts = import ./fonts.nix;
  ssh = import ./ssh.nix;

  # Locales
  amsterdam = import ./amsterdam.nix;

  # CLI stuff
  cli = import ./cli.nix;
  utils = import ./utils.nix;

  # Other apps
  hledger = ./hledger.nix;
  
}
