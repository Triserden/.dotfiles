{lib, pkgs, config, ...}: 
{
  options = {
    nwmanager.enable = lib.mkEnableOption "Enable nwmanager.";
  };
  
  config = lib.mkIf config.nwmanager.enable {
    networking.networkmanager.enable = true;
    systemd.services.NetworkManager-wait-online.enable = false;
    programs.nm-applet.enable = true;
    environment.systemPackages = [
      pkgs.networkmanagerapplet
    ];
  };
}
