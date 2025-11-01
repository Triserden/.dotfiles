{pkgs, ...}:
{
  environment.systemPackages = [
    pkgs.nautilus
    pkgs.nautilus-open-any-terminal
    pkgs.sushi

  ];
}
