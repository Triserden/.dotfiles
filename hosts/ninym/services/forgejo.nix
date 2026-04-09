# Auto-generated using compose2nix v0.3.1.
{ pkgs, lib, ... }:

{
  # Runtime
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  # Containers
  virtualisation.oci-containers.containers."docker_dind" = {
    image = "docker:dind";
    cmd = [ "dockerd" "-H" "tcp://0.0.0.0:2375" "--tls=false" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=docker-in-docker"
      "--network=forgejo_default"
      "--privileged"
    ];
  };
  systemd.services."docker-docker_dind" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-forgejo_default.service"
    ];
    requires = [
      "docker-network-forgejo_default.service"
    ];
    partOf = [
      "docker-compose-forgejo-root.target"
    ];
    wantedBy = [
      "docker-compose-forgejo-root.target"
    ];
  };
  virtualisation.oci-containers.containers."forgejo" = {
    image = "codeberg.org/forgejo/forgejo:14-rootless";
    environment = {
      "FORGEJO__database__DB_TYPE" = "postgres";
      "FORGEJO__database__HOST" = "db:5432";
      "FORGEJO__database__NAME" = "forgejo";
      "FORGEJO__database__PASSWD" = "forgejo";
      "FORGEJO__database__USER" = "forgejo";
      "USER_GID" = "1000";
      "USER_UID" = "1000";
    };
    volumes = [
      "/data/forgejo/data:/var/lib/gitea:rw"
      "/etc/localtime:/etc/localtime:ro"
    ];
    labels = {
      "traefik.enable" = "true";
      #"traefik.http.routers.forgejo-ssh.entrypoints" = "websecure";
      #"traefik.http.routers.forgejo-ssh.rule" = "Host(`ssh.forgejo.local.triserden.dev`)";
      #"traefik.http.routers.forgejo-ssh.tls.certresolver" = "cloudflare";
      #"traefik.http.routers.forgejo-ssh.service" = "srv-forgejo-ssh";

      "traefik.http.routers.forgejo.entrypoints" = "websecure";
      "traefik.http.routers.forgejo.rule" = "Host(`forgejo.local.triserden.dev`)";
      "traefik.http.routers.forgejo.tls.certresolver" = "cloudflare";
      "traefik.http.routers.forgejo.service" = "srv-forgejo";

      # "traefik.http.services.srv-forgejo-ssh.loadbalancer.server.port" = "2222";
      "traefik.http.services.srv-forgejo.loadbalancer.server.port" = "3000";
    };
    dependsOn = [
      "forgejo-db"
    ];
    user = "1000:1000";
    log-driver = "journald";
    extraOptions = [
      "--network-alias=server"
      "--network=internal"
      "--network=forgejo_default"
    ];
  };
  systemd.services."docker-forgejo" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-forgejo_default.service"
    ];
    requires = [
      "docker-network-forgejo_default.service"
    ];
    partOf = [
      "docker-compose-forgejo-root.target"
    ];
    wantedBy = [
      "docker-compose-forgejo-root.target"
    ];
  };
  virtualisation.oci-containers.containers."forgejo-db" = {
    image = "postgres:14";
    environment = {
      "POSTGRES_DB" = "forgejo";
      "POSTGRES_PASSWORD" = "forgejo";
      "POSTGRES_USER" = "forgejo";
    };
    volumes = [
      "/data/forgejo/postgres:/var/lib/postgresql/data:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=db"
      "--network=forgejo_default"
    ];
  };
  systemd.services."docker-forgejo-db" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-forgejo_default.service"
    ];
    requires = [
      "docker-network-forgejo_default.service"
    ];
    partOf = [
      "docker-compose-forgejo-root.target"
    ];
    wantedBy = [
      "docker-compose-forgejo-root.target"
    ];
  };
  virtualisation.oci-containers.containers."forgejo-runner" = {
    image = "data.forgejo.org/forgejo/runner:11";
    environment = {
      "DOCKER_HOST" = "tcp://docker-in-docker:2375";
    };
    volumes = [
      "/data/forgejo/runner/data:/data:rw"
    ];
    cmd = [ "/bin/sh" "-c" "while : ; do sleep 1 ; done ;" ];
    dependsOn = [
      "docker_dind"
    ];
    user = "1001:1001";
    log-driver = "journald";
    extraOptions = [
      "--network-alias=runner"
      "--network=forgejo_default"
    ];
  };
  systemd.services."docker-forgejo-runner" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-forgejo_default.service"
    ];
    requires = [
      "docker-network-forgejo_default.service"
    ];
    partOf = [
      "docker-compose-forgejo-root.target"
    ];
    wantedBy = [
      "docker-compose-forgejo-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-forgejo_default" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f forgejo_default";
    };
    script = ''
      docker network inspect forgejo_default || docker network create forgejo_default
    '';
    partOf = [ "docker-compose-forgejo-root.target" ];
    wantedBy = [ "docker-compose-forgejo-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-forgejo-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}

