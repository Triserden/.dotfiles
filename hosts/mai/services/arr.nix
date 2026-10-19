{inputs, config, ...}:
  let secretsFolder = builtins.toString inputs.secrets;
  in {
   sops.secrets = {
    "arr.env" = {};
    "sonarr.env" = {};
    "recyclarr.env" = {};
    "qbittorrent.env" = {};
    "navidrome.env" = {};
    "cwa.env" = {};
    "shelfmark.env" = {};
    "radarr.env" = {};
    "prowlarr.env" = {};
    "lidarr.env" = {};
  };

    virtualisation.oci-containers.compose-containers."arr" = {
    path = ./compose-files/arr-stack.yml;
    convertOptions = {
      sops_file = "${secretsFolder}/sops/${config.host.hostname}/services/arr.yaml"; 
      runtime = "docker";
    };
  };
}
