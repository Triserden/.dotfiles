{pkgs, ...}:
{
  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    # winetricks (all versions)
    winetricks
    prismlauncher
    # native wayland support (unstable)
    wineWowPackages.waylandFull
  ];
}
