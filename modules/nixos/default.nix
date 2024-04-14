{
  # Core modules
  nwmanager = import ./nwmanager.nix; 
  hyprland = import ./hyprland.nix;
  firefox = import ./firefox.nix;
  gpg = import ./gpg.nix;
  git = import ./git.nix;
  tailscale = import ./tailscale.nix;

  # CLI stuff
  cli = import ./cli.nix;
}
