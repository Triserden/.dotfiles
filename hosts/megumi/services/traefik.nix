# Auto-generated using compose2nix v0.3.1.
{ config, inputs, lib, ... }:

let secretsFolder = builtins.toString inputs.secrets;
in {
  # Runtime
  sops.secrets."services/traefik.env" = {
    sopsFile =
      "${secretsFolder}/sops/${config.host.hostname}/services/traefik.env";
    format = "dotenv";
  };

  # Containers
  virtualisation.oci-containers.containers."traefik" = {
    image = "traefik:v3.6.1";
    volumes = [
      "/data/traefik/letsencrypt:/letsencrypt:rw"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
    ];
    ports =
      [ "100.96.36.91:80:80/tcp" "100.96.36.91:443:443/tcp" "8080:8080/tcp" ];
    cmd = [
      "--api=true"
      "--providers.docker=true"
      "--providers.docker.exposedbydefault=false"
      "--entryPoints.web.address=:80"
      "--entrypoints.websecure.address=:443"
      "--entrypoints.web.http.redirections.entrypoint.to=websecure"
      "--entrypoints.web.http.redirections.entrypoint.scheme=https"
      "--certificatesresolvers.cloudflare.acme.dnschallenge=true"
      "--certificatesresolvers.cloudflare.acme.dnschallenge.provider=cloudflare"
      "--certificatesresolvers.cloudflare.acme.email=${inputs.secrets.emails.cloudflare_acme_email}"
      "--certificatesresolvers.cloudflare.acme.storage=/letsencrypt/acme.json"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.dashboard.rule" =
        "Host(`traefik.mai.internal.triserden.dev`) && (PathPrefix(`/api`) || PathPrefix(`/dashboard`))";
      "traefik.http.routers.dashboard.service" = "api@internal";
      "traefik.http.routers.dashboard.entrypoints" = "websecure";
      "traefik.http.routers.dashboard.tls.certresolver" = "cloudflare";
    };
    environmentFiles = [ config.sops.secrets."services/traefik.env".path ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=traefik"
      "--network=internal"
      "--security-opt=no-new-privileges:true"
    ];
  };
  systemd.services."docker-traefik" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    partOf = [ "docker-compose-traefik-root.target" ];
    wantedBy = [ "docker-compose-traefik-root.target" ];
  };
  virtualisation.oci-containers.containers."traefik-whoami" = {
    image = "traefik/whoami";
    labels = {
      "traefik.enable" = "true";
      "traefik.http.services.whoami.loadbalancer.server.port" = "80";
      "traefik.http.routers.whoami.entrypoints" = "websecure";
      "traefik.http.routers.whoami.tls.certresolver" = "cloudflare";
      "traefik.http.routers.whoami.rule" =
        "Host(`whoami.mai.internal.triserden.dev`)";
    };
    log-driver = "journald";
    extraOptions = [ "--network-alias=whoami" "--network=internal" ];
  };
  systemd.services."docker-traefik-whoami" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    partOf = [ "docker-compose-traefik-root.target" ];
    wantedBy = [ "docker-compose-traefik-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-traefik-root" = {
    unitConfig = { Description = "Traefik docker compose root"; };
    wantedBy = [ "multi-user.target" ];
  };
}
