{ config, pkgs, ... }: {
  virtualisation.docker = {
    enable = true;
    storageDriver = config.host.docker_fs;

    daemon.settings = {
      pruning = {
        enabled = true;
        interval = "24h";
      };
    };
  };

  # In order to route to privileged ports, use firewall to forward traffic.
  # https://wiki.nixos.org/wiki/Docker#Using_Privileged_Ports_for_Rootless_Docker

  boot.kernel.sysctl = {
    "net.ipv4.conf.eth0.forwarding" = 1; # enable port forwarding
  };

  systemd.services.create-docker-networks = {
    description = "Create docker networks manually";
    after = [ "docker.service" ];
    wants = [ "docker.service" ];
    wantedBy = [ "docker-traefik.service" "docker-postgres.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      ${pkgs.docker}/bin/docker network inspect internal || ${pkgs.docker}/bin/docker network create internal
      ${pkgs.docker}/bin/docker network inspect external || ${pkgs.docker}/bin/docker network create external
    '';
  };
}
