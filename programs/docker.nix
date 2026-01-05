{ config, ... }: {
  virtualisation.docker = {
    enable = true;
    storageDriver = config.host.docker_fs;

    daemon.settings = { };
  };

  # In order to route to privileged ports, use firewall to forward traffic.
  # https://wiki.nixos.org/wiki/Docker#Using_Privileged_Ports_for_Rootless_Docker

  boot.kernel.sysctl = {
    "net.ipv4.conf.eth0.forwarding" = 1; # enable port forwarding
  };

}
