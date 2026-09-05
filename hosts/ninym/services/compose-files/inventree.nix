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
  virtualisation.oci-containers.containers."inventree-cache" = {
    image = "redis:7-alpine";
    volumes = [
      "/data/inventree-data/redis:/data:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=inventree-cache"
      "--network=inventree_default"
    ];
  };
  systemd.services."docker-inventree-cache" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-inventree_default.service"
    ];
    requires = [
      "docker-network-inventree_default.service"
    ];
    partOf = [
      "docker-compose-inventree-root.target"
    ];
    wantedBy = [
      "docker-compose-inventree-root.target"
    ];
  };
  virtualisation.oci-containers.containers."inventree-db" = {
    image = "postgres:17";
    environment = {
      "PGDATA" = "/var/lib/postgresql/data/pgdb";
      "POSTGRES_DB" = "inventree";
      "POSTGRES_PASSWORD" = "Overhead-Chowder2-Primary-Flap-Resource";
      "POSTGRES_USER" = "latitude";
    };
    volumes = [
      "/data/inventree-data:/var/lib/postgresql/data:rw,z"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=inventree-db"
      "--network=inventree_default"
    ];
  };
  systemd.services."docker-inventree-db" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-inventree_default.service"
    ];
    requires = [
      "docker-network-inventree_default.service"
    ];
    partOf = [
      "docker-compose-inventree-root.target"
    ];
    wantedBy = [
      "docker-compose-inventree-root.target"
    ];
  };
  virtualisation.oci-containers.containers."inventree-server" = {
    image = "inventree/inventree:stable";
    environment = {
      "COMPOSE_PROJECT_NAME" = "inventree";
      "INVENTREE_ADMIN_EMAIL" = "admin@coveilon.com";
      "INVENTREE_ADMIN_PASSWORD" = "Grating-Unopposed-Concierge4-Decency-Creasing";
      "INVENTREE_ADMIN_USER" = "InventreeAdmin";
      "INVENTREE_AUTO_UPDATE" = "True";
      "INVENTREE_CACHE_ENABLED" = "True";
      "INVENTREE_CACHE_HOST" = "inventree-cache";
      "INVENTREE_CACHE_PORT" = "6379";
      "INVENTREE_DB_ENGINE" = "postgresql";
      "INVENTREE_DB_HOST" = "inventree-db";
      "INVENTREE_DB_NAME" = "inventree";
      "INVENTREE_DB_PASSWORD" = "Overhead-Chowder2-Primary-Flap-Resource";
      "INVENTREE_DB_PORT" = "5432";
      "INVENTREE_DB_USER" = "latitude";
      "INVENTREE_EXT_VOLUME" = "/data/inventree-data";
      "INVENTREE_GUNICORN_TIMEOUT" = "90";
      "INVENTREE_LOG_LEVEL" = "WARNING";
      "INVENTREE_PLUGINS_ENABLED" = "True";
      "INVENTREE_SERVER" = "http://inventree-server:8000";
      "INVENTREE_SITE_URL" = "https://inventree.coveilon.com";
      "INVENTREE_TAG" = "stable";
      "INVENTREE_USE_X_FORWARDED_HOST" = "True";
      "INVENTREE_USE_X_FORWARDED_PORT" = "True";
      "INVENTREE_USE_X_FORWARDED_PROTO" = "True";
      "INVENTREE_WEB_PORT" = "8000";
    };
    volumes = [
      "/data/inventree-data:/home/inventree/data:rw,z"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.fireflyimporter.entrypoints" = "websecure";
      "traefik.http.routers.fireflyimporter.rule" = "Host(`inventree.coveilon.com`)";
      "traefik.http.routers.fireflyimporter.tls.certresolver" = "cloudflare";
      "traefik.http.services.fireflyimporter.loadbalancer.server.port" = "8000";
    };
    dependsOn = [
      "inventree-cache"
      "inventree-db"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=inventree-server"
      "--network=inventree_default"
    ];
  };
  systemd.services."docker-inventree-server" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-inventree_default.service"
    ];
    requires = [
      "docker-network-inventree_default.service"
    ];
    partOf = [
      "docker-compose-inventree-root.target"
    ];
    wantedBy = [
      "docker-compose-inventree-root.target"
    ];
  };
  virtualisation.oci-containers.containers."inventree-worker" = {
    image = "inventree/inventree:stable";
    volumes = [
      "/data/inventree-data:/home/inventree/data:rw,z"
    ];
    cmd = [ "invoke" "worker" ];
    dependsOn = [
      "inventree-server"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=inventree-worker"
      "--network=inventree_default"
    ];
  };
  systemd.services."docker-inventree-worker" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-inventree_default.service"
    ];
    requires = [
      "docker-network-inventree_default.service"
    ];
    partOf = [
      "docker-compose-inventree-root.target"
    ];
    wantedBy = [
      "docker-compose-inventree-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-inventree_default" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f inventree_default";
    };
    script = ''
      docker network inspect inventree_default || docker network create inventree_default
    '';
    partOf = [ "docker-compose-inventree-root.target" ];
    wantedBy = [ "docker-compose-inventree-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-inventree-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
