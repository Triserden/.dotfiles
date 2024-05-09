{pkgs, ...}:

{
  environment.systemPackages = [
    pkgs.unstable.hledger
  ];
}
