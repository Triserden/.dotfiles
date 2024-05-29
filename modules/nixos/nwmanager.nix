{pkgs, ...}: 
{
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;
  environment.systemPackages = [
    pkgs.networkmanagerapplet
  ];
}
