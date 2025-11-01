{inputs, pkgs, ...}:
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "Nerd Fonts: Jetbrains";
        };
      };
  };
}
