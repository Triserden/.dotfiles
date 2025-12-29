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
        hostId = lib.mkOption {
          type = lib.types.str;
          description = "HostID for zfs";
        };
      };
    };
  };
}
