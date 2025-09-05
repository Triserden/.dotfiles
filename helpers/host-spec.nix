{config, pkgs, lib, ...}:
{
  options.hostSpec = lib.mkOption {
    type = lib.types.submodule {
      options = {
        username = lib.mkOption {
          type = lib.types.str;
          description = "Username of host";
        };
        hostname = lib.mkOption {
          type = lib.types.str;
          description = "Hostname of host";
        };
        home = lib.mkOption {
          type = lib.types.str;
          description = "Homedir of user";
          default = "/home/${config.hostSpec.username}";
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
