{inputs, config, lib, ...}:
  let secretsFolder = builtins.toString inputs.secrets;
  in {
   sops.secrets =  {
    "arr.env" = {sopsFile = "${secretsFolder}/sops/${config.host.hostname}/services/arr.yaml"; };
    "sonarr.env" = {sopsFile = "${secretsFolder}/sops/${config.host.hostname}/services/arr.yaml"; };
    "recyclarr.env" = {sopsFile = "${secretsFolder}/sops/${config.host.hostname}/services/arr.yaml"; };
    "qbittorrent.env" = {sopsFile = "${secretsFolder}/sops/${config.host.hostname}/services/arr.yaml"; };
    "navidrome.env" = {sopsFile = "${secretsFolder}/sops/${config.host.hostname}/services/arr.yaml"; };
    "cwa.env" = {sopsFile = "${secretsFolder}/sops/${config.host.hostname}/services/arr.yaml"; };
    "shelfmark.env" = {sopsFile = "${secretsFolder}/sops/${config.host.hostname}/services/arr.yaml"; };
    "radarr.env" = {sopsFile = "${secretsFolder}/sops/${config.host.hostname}/services/arr.yaml"; };
    "prowlarr.env" = {sopsFile = "${secretsFolder}/sops/${config.host.hostname}/services/arr.yaml"; };
    "lidarr.env" = {sopsFile = "${secretsFolder}/sops/${config.host.hostname}/services/arr.yaml"; };
  };

    virtualisation.oci-containers.compose-containers."arr" = {
    path = ./compose-files/arr-stack.yml;
    convertOptions = {
      sops_file = "${secretsFolder}/sops/${config.host.hostname}/services/arr.yaml"; 
      runtime = "docker";
    };
  };

  # Load media disk at boot
  fileSystems."/media" = {
  device = "/dev/disk/by-uuid/b7c4ea53-2975-4bed-9eb0-ed86ee608918";
  fsType = "ext4";
  options = [ # If you don't have this options attribute, it'll default to "defaults" 
    # boot options for fstab. Search up fstab mount options you can use
    "x-systemd.automount" 
    "exec" # Permit execution of binaries and other executable files
    "user"
  ];
};
}
