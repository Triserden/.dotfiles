{config, ...}: {
  virtualisation.quadlet = let
    inherit (config.virtualisation.quadlet) networks pods;
  in {
    containers = {
      nginx = {
        containerConfig = {
          image = "docker.io/library/nginx:trixie-perl";
          networks = [networks.internal.ref];
          publishPorts = ["100.76.229.23:80:80" "100.76.229.23:443:443"];
        };
        serviceConfig = {
          TimeoutStartSec = "30";
        };
      };
    };
  };
}
