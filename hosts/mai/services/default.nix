{ pkgs, ... }: {
  imports = [ ./traefik.nix ./firefly3.nix ./paperless.nix ./hoarder.nix ];

  systemd.services.docker-networks = {
    script = ''
     ${pkgs.docker}/bin/docker network ls|grep internal > /dev/null ||  ${pkgs.docker}/bin/docker network create internal
     ${pkgs.docker}/bin/docker network ls|grep externall > /dev/null ||  ${pkgs.docker}/bin/docker network create external
    '';
    serviceConfig = { 
      RestartSec = 5;
      Type = "oneshot";
    };
    wantedBy = ["multi-user.target"];
    wants = ["docker.service"];
    after = ["docker.service"];
  };
}

