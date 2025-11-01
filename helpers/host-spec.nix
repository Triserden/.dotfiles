{config, pkgs, lib, ...}:
{
  options.hostSpec = lib.mkOption {
    type = lib.types.submodule {
      options = {
        primaryUser = lib.mkOption {
          type = lib.types.str;
          description = "Primary user of host";
        };
        users = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "Usernames of host";
        };
        hostname = lib.mkOption {
          type = lib.types.str;
          description = "Hostname of host";
        };
        home = lib.mkOption {
          type = lib.types.str;
          description = "Homedir of user";
          default = "/home/${config.hostSpec.primaryUser}";
        };
        stateVersion = lib.mkOption {
          type = lib.types.str;
          description = "First NixOS version";
        };
        nixOSVersion = lib.mkOption {
          type = lib.types.str;
          description = "NixOS version";
        };
      };
    };
  };
}
