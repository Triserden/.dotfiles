{inputs, ...}:
{
  imports = [
    inputs.nixvim.nixosModules.nixvim
  ];
  programs.nixvim = {
  enable = true;
  imports = [ inputs.Neve.nixvimModule ];
  # Then configure Nixvim as usual, you might have to lib.mkForce some of the settings
  colorschemes.catppuccin.enable = true;
};
}
