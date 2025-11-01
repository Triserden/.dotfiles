{pkgs, ...}:
{
  imports = [
    ./pipewire.nix
  ];
  programs.hyprland.enable = true;

  environment.systemPackages = [
    pkgs.dunst
    pkgs.hyprpolkitagent
  ];
}
