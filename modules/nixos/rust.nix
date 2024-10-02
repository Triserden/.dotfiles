{lib, config, pkgs, ...}: 
{
  options = {
    rust.enable = lib.mkEnableOption "Enable rust development.";
  };
  
  config = lib.mkIf config.rust.enable {
    environment.systemPackages = [
      pkgs.unstable.jetbrains.rust-rover
      pkgs.unstable.devenv
    ];
    programs.direnv.enable = true;
    nix.extraOptions = ''
      extra-substituters = https://devenv.cachix.org;
      extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=;
    '';
  };
}
