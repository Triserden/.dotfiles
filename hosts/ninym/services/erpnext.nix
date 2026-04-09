# Auto-generated using compose2nix v0.3.1.
{ pkgs, config, inputs, lib, ... }:

let secretsFolder = builtins.toString inputs.secrets;
in {
  # Runtime
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  sops.secrets."services/erpnext.env" = {
    sopsFile =
      "${secretsFolder}/sops/${config.host.hostname}/services/erpnext.env";
    format = "dotenv";
  };
  sops.secrets."services/traefik.env" = {
    sopsFile =
      "${secretsFolder}/sops/${config.host.hostname}/services/traefik.env";
    format = "dotenv";
  };
  # Containers
  ####
  # HOW TO FINISH INSTALLATION OF THIS DAMMNED THING
  # CREATE THE SITE
  # docker exec -it erpnext-backenf bench new-site <url> --mariadb-user-host-login-scope='172.%.%.%' --admin-password=<adminpaswd> --db-root-password=<databasepasswd> --db-root-username=root --install-app erpnext (or anyfrom frappe i think) --set-default
  # Login is Administrator
  # Note: Extra steps needed for other apps
virtualisation.oci-containers.containers."erpnext-backend" = {
    image = "frappe_custom:16";
    volumes = [
      "/data/erpnext/erpnext_sites:/home/frappe/frappe-bench/sites:rw"
    ];
    dependsOn = [
      "erpnext-configurator"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=backend"
      "--network=erpnext_default"
    ];
  };
  systemd.services."docker-erpnext-backend" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-erpnext_default.service"
    ];
    requires = [
      "docker-network-erpnext_default.service"
    ];
    partOf = [
      "docker-compose-erpnext-root.target"
    ];
    wantedBy = [
      "docker-compose-erpnext-root.target"
    ];
  };
 
    virtualisation.oci-containers.containers."erpnext-configurator" = {
    image = "frappe_custom:16";
    environment = {
      "DB_HOST" = "db";
      "DB_PORT" = "3306";
      "REDIS_CACHE" = "erpnext-redis-cache:6379";
      "REDIS_QUEUE" = "erpnext-redis-queue:6379";
      "SOCKETIO_PORT" = "9000";
    };
    volumes = [
      "/data/erpnext/erpnext_sites:/home/frappe/frappe-bench/sites:rw"
    ];
    cmd = [ "-c" "echo \"{}\" > sites/common_site_config.json; ls -1 apps > sites/apps.txt; bench set-config -g db_host $DB_HOST; bench set-config -gp db_port $DB_PORT; bench set-config -g redis_cache \"redis://$REDIS_CACHE\"; bench set-config -g redis_queue \"redis://$REDIS_QUEUE\"; bench set-config -g redis_socketio \"redis://$REDIS_QUEUE\"; bench set-config -gp socketio_port $SOCKETIO_PORT;
  " ];
    dependsOn = [
      "erpnext-db"
      "erpnext-redis-cache"
      "erpnext-redis-queue"
    ];
    log-driver = "journald";
    extraOptions = [
       "--entrypoint=/bin/sh"
      "--network-alias=configurator"
      "--network=erpnext_default"
    ];
  };
  
    systemd.services."docker-erpnext-configurator" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "on-failure";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-erpnext_default.service"
    ];
    requires = [
      "docker-network-erpnext_default.service"
    ];
    partOf = [
      "docker-compose-erpnext-root.target"
    ];
    wantedBy = [
      "docker-compose-erpnext-root.target"
    ];
  };
  virtualisation.oci-containers.containers."erpnext-db" = {
    image = "mariadb:11.8";
    environment = {
      "MARIADB_AUTO_UPGRADE" = "1";
    };
        environmentFiles = [ config.sops.secrets."services/erpnext.env".path ];
    volumes = [
      "/data/erpnext/erpnext_db-data:/var/lib/mysql:rw"
    ];
    cmd = [ "--character-set-server=utf8mb4" "--collation-server=utf8mb4_unicode_ci" "--skip-character-set-client-handshake" "--skip-innodb-read-only-compressed" ];
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=[\"healthcheck.sh\", \"--connect\", \"--innodb_initialized\"]"
      "--health-interval=5s"
      "--health-retries=5"
      "--health-start-period=5s"
      "--health-timeout=5s"
      "--network-alias=db"
      "--network=erpnext_default"
    ];
  };
  systemd.services."docker-erpnext-db" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-erpnext_default.service"
    ];
    requires = [
      "docker-network-erpnext_default.service"
    ];
    partOf = [
      "docker-compose-erpnext-root.target"
    ];
    wantedBy = [
      "docker-compose-erpnext-root.target"
    ];
  };
  virtualisation.oci-containers.containers."erpnext-frontend" = {
    image = "frappe_custom:16";
    environment = {
      "BACKEND" = "backend:8000";
      "CLIENT_MAX_BODY_SIZE" = "50m";
      "FRAPPE_SITE_NAME_HEADER" = "$host";
      "PROXY_READ_TIMEOUT" = "120";
      "SOCKETIO" = "websocket:9000";
      "UPSTREAM_REAL_IP_ADDRESS" = "0.0.0.0";
      "UPSTREAM_REAL_IP_HEADER" = "X-Forwarded-For";
      "UPSTREAM_REAL_IP_RECURSIVE" = "off";
    };
    volumes = [
      "/data/erpnext/erpnext_sites:/home/frappe/frappe-bench/sites:rw"
    ];
    ports = [
      "8081:8080/tcp"
    ];
    cmd = [ "nginx-entrypoint.sh" ];
    dependsOn = [
      "erpnext-backend"
      "erpnext-websocket"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=frontend"
      "--network=erpnext_default"
      "--network=internal"
        ];
        environmentFiles = [ config.sops.secrets."services/erpnext.env".path ];
        labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.erpnext.entrypoints" = "websecure";
      "traefik.http.routers.erpnext.rule" =
        "Host(`erpnext.local.triserden.dev`) || Host(`hrms.local.triserden.dev`)";
      "traefik.http.routers.erpnext.tls.certresolver" = "cloudflare";
      "traefik.http.services.erpnext.loadbalancer.server.port" = "8080";
    };
  };
  systemd.services."docker-erpnext-frontend" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-erpnext_default.service"
    ];
    requires = [
      "docker-network-erpnext_default.service"
    ];
    partOf = [
      "docker-compose-erpnext-root.target"
    ];
    wantedBy = [
      "docker-compose-erpnext-root.target"
    ];
  };
  virtualisation.oci-containers.containers."erpnext-queue-long" = {
    image = "frappe_custom:16";
    volumes = [
      "/data/erpnext/erpnext_sites:/home/frappe/frappe-bench/sites:rw"
    ];
    cmd = [ "bench" "worker" "--queue" "long,default,short" ];
    dependsOn = [
      "erpnext-configurator"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=queue-long"
      "--network=erpnext_default"
    ];
  };
  systemd.services."docker-erpnext-queue-long" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-erpnext_default.service"
    ];
    requires = [
      "docker-network-erpnext_default.service"
    ];
    partOf = [
      "docker-compose-erpnext-root.target"
    ];
    wantedBy = [
      "docker-compose-erpnext-root.target"
    ];
  };
  virtualisation.oci-containers.containers."erpnext-queue-short" = {
    image = "frappe_custom:16";
    volumes = [
      "/data/erpnext/erpnext_sites:/home/frappe/frappe-bench/sites:rw"
    ];
    cmd = [ "bench" "worker" "--queue" "short,default" ];
    dependsOn = [
      "erpnext-configurator"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=queue-short"
      "--network=erpnext_default"
    ];
  };
  systemd.services."docker-erpnext-queue-short" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-erpnext_default.service"
    ];
    requires = [
      "docker-network-erpnext_default.service"
    ];
    partOf = [
      "docker-compose-erpnext-root.target"
    ];
    wantedBy = [
      "docker-compose-erpnext-root.target"
    ];
  };
  virtualisation.oci-containers.containers."erpnext-redis-cache" = {
    image = "redis:6.2-alpine";
    log-driver = "journald";
    extraOptions = [
      "--network-alias=redis-cache"
      "--network=erpnext_default"
    ];
  };
  systemd.services."docker-erpnext-redis-cache" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-erpnext_default.service"
    ];
    requires = [
      "docker-network-erpnext_default.service"
    ];
    partOf = [
      "docker-compose-erpnext-root.target"
    ];
    wantedBy = [
      "docker-compose-erpnext-root.target"
    ];
  };
  virtualisation.oci-containers.containers."erpnext-redis-queue" = {
    image = "redis:6.2-alpine";
    volumes = [
      "/data/erpnext/erpnext_redis-queue-data:/data:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=redis-queue"
      "--network=erpnext_default"
    ];
  };
  systemd.services."docker-erpnext-redis-queue" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-erpnext_default.service"
    ];
    requires = [
      "docker-network-erpnext_default.service"
    ];
    partOf = [
      "docker-compose-erpnext-root.target"
    ];
    wantedBy = [
      "docker-compose-erpnext-root.target"
    ];
  };
  virtualisation.oci-containers.containers."erpnext-scheduler" = {
    image = "frappe_custom:16";
    volumes = [
      "/data/erpnext/erpnext_sites:/home/frappe/frappe-bench/sites:rw"
    ];
    cmd = [ "bench" "schedule" ];
    dependsOn = [
      "erpnext-configurator"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=scheduler"
      "--network=erpnext_default"
    ];
  };
  systemd.services."docker-erpnext-scheduler" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-erpnext_default.service"
    ];
    requires = [
      "docker-network-erpnext_default.service"
    ];
    partOf = [
      "docker-compose-erpnext-root.target"
    ];
    wantedBy = [
      "docker-compose-erpnext-root.target"
    ];
  };
  virtualisation.oci-containers.containers."erpnext-websocket" = {
    image = "frappe_custom:16";
    volumes = [
      "/data/erpnext/erpnext_sites:/home/frappe/frappe-bench/sites:rw"
    ];
    cmd = [ "node" "/home/frappe/frappe-bench/apps/frappe/socketio.js" ];
    dependsOn = [
      "erpnext-configurator"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=websocket"
      "--network=erpnext_default"
    ];
  };
  systemd.services."docker-erpnext-websocket" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-erpnext_default.service"
    ];
    requires = [
      "docker-network-erpnext_default.service"
    ];
    partOf = [
      "docker-compose-erpnext-root.target"
    ];
    wantedBy = [
      "docker-compose-erpnext-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-erpnext_default" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f erpnext_default";
    };
    script = ''
      docker network inspect erpnext_default || docker network create erpnext_default
    '';
    partOf = [ "docker-compose-erpnext-root.target" ];
    wantedBy = [ "docker-compose-erpnext-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-erpnext-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}


