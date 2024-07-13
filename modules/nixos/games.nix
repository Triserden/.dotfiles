{pkgs, ...}:
{
  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    # winetricks (all versions)
    winetricks
    # native wayland support (unstable)
    wineWowPackages.waylandFull
    (unstable.prismlauncher.override { additionalLibs = [nss nspr mesa alsa-lib glib]; })
  ];
}
