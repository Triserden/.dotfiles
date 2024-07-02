{pkgs, ...}:
{
  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    # winetricks (all versions)
    winetricks
    unstable.prismlauncher-unwrapped
    # native wayland support (unstable)
    wineWowPackages.waylandFull
  ];
}
