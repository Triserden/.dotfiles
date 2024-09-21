{lib, pkgs, config, ...}: 
{
  options = {
    printers.enable = lib.mkEnableOption "Enable printer module.";
  };
  
  config = lib.mkIf config.printers.enable {
    environment.systemPackages = [
      pkgs.sane-backends
      pkgs.naps2
    ];
  
    hardware.sane = {
      enable = true; # enables support for SANE scanners
      extraBackends = [ pkgs.hplipWithPlugin ];
    };
    users.users.triserden.extraGroups = [ "scanner" "lp" ];

    services.printing.enable = true;

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
        userServices = true;
      };
    };
  };
}