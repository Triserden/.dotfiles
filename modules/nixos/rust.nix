{lib, config, pkgs, ...}: 
{
  options = {
    rust.enable = lib.mkEnableOption "Enable rust development.";
  };
  
  config = lib.mkIf config.rust.enable {
    environment.systemPackages = [
      pkgs.unstable.jetbrains.rust-rover
      pkgs.devenv
    ];
    programs.direnv.enable = true;
  };
}
