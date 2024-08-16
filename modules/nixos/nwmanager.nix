{pkgs, ...}: 
{
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;
  programs.nm-applet.enable = true;
  environment.systemPackages = [
    pkgs.networkmanagerapplet
  ];
}
