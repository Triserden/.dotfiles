{pkgs, ...}:
{
  
  environment.systemPackages = [
    pkgs.sane-backends
  ];
  
  hardware.sane = {
    enable = true; # enables support for SANE scanners
    extraBackends = [ pkgs.hplipWithPlugin ];
  };
  users.users.triserden.extraGroups = [ "scanner" "lp" ];

  services.printing.enable = true;

  services.avahi = {
      enable = true;
      nssmdns = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
        userServices = true;
      };
    };
}
