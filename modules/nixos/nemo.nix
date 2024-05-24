{pkgs, ...}:
{
  environment.systemPackages = [
    pkgs.cinnamon.nemo
  ];
}
