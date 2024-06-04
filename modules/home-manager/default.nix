{
  cli = import ./cli.nix;
  alacritty = import ./alacritty.nix;
  git = import ./git.nix;
  ssh = import ./ssh.nix;
  hyprland = import ./hyprland.nix;
  waybar = import ./waybar.nix;
  networkmanager-dmenu = import ./networkmanager-dmenu.nix;
  bluetooth = import ./bluetooth.nix;
}
