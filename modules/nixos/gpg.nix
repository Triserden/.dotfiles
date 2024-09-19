{lib, pkgs, config, ...}: 
{
  options = {
    gpg.enable = lib.mkEnableOption "Enable GPG module.";
  };
  
  config = lib.mkIf config.gpg.enable {
    programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };
  };
}
