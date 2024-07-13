{pkgs, ...}:
{
  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    # winetricks (all versions)
    winetricks
    # native wayland support (unstable)
    wineWowPackages.waylandFull
    (unstable.prismlauncher.override { additionalLibs = [nss nspr mesa alsa-lib libcef ungoogled-chromium  xorg.libX11 xorg.libxcb libarchive gtk3 openjdk17 libcef pcre2]; })
  ];
}
