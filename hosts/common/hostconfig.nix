{ config, pkgs, lib, ... }: {
  options.host = lib.mkOption {
    type = lib.types.submodule {
      options = {
        user = lib.mkOption {
          type = lib.types.str;
          description = "Primary user of host";
        };
        hostname = lib.mkOption {
          type = lib.types.str;
          description = "Hostname of host";
        };
        home = lib.mkOption {
          type = lib.types.str;
          description = "Homedir of user";
          default = "/home/${config.host.user}";
        };
        stateVersion = lib.mkOption {
          type = lib.types.str;
          description = "First NixOS version";
        };
        docker_fs = lib.mkOption {
          type = lib.types.enum [
            "aufs"
            "btrfs"
            "devicemapper"
            "overlay"
            "overlay2"
            "zfs"
          ];
          description = "Filesystem type for docker.";
        };
        hostId = lib.mkOption {
          type = lib.types.str;
          description = "HostID for zfs";
        };
      };
    };
  };
}
