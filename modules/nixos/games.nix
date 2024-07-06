{pkgs, ...}:
{
  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    # winetricks (all versions)
    winetricks
    # native wayland support (unstable)
    wineWowPackages.waylandFull
  
    (pkgs.runCommand "prismlauncher" {
      buildInputs = [ pkgs.makeWrapper ];
    } ''
    mkdir $out
    ln -s ${pkgs.unstable.prismlauncher}/* $out
    mkdir $out/lib
    ln -s ${pkgs.nss}/lib/* $out/lib
    '')
  ];
}
