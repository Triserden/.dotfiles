{pkgs, config, ...}:
{
  stylix = {
    image = ../../hosts/megumi/wallpaper.png;
    polarity = "dark";
    fonts = {
      sansSerif = {
        package = pkgs.open-sans;
        name = "Open Sans";
      };
      serif = {
        package = pkgs.noto-fonts-cjk-serif;
        name = "Noto Fonts";
      };
      monospace = {
        package = pkgs.jetbrains-mono;
        name = "Jetbrains Mono";
      };
    };
  };
  fonts.packages = [
      (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      pkgs.open-sans
      pkgs.noto-fonts-cjk-serif
  ];
}
