{pkgs, ...}:

{
  programs.mtr.enable = true;
  environment.systemPackages = [
    pkgs.wget
    pkgs.ripgrep
  ];
}
