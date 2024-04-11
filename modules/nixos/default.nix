{
  # Core modules
  nwmanager = import ./nwmanager.nix; 
  hyprland = import ./hyprland.nix;
  firefox = import ./firefox.nix;
  gpg = import ./gpg.nix;
  git = import ./git.nix;
  wget = import ./wget.nix;

  # Shell replacements
  bat = import ./bat.nix; # cat replacement
  nushell = import ./nushell.nix; # shell replacement
  alacritty = import ./alacritty.nix;
  eza = import ./exa/nix; #ls replacement

}
