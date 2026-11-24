{ pkgs, ... }: {
  imports = [ ../programs/foot.nix ../programs/nvim.nix ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttfliberation_ttf
  ];

  environment.systemPackages = with pkgs; [ btop bat eza caligula ];
}
