{lib, pkgs, config, ...}: 
{
  options = {
    docker.enable = lib.mkEnableOption "Installs and enables docker on system.";
    docker.storageDriver = lib.mkOption {
      type = lib.types.str;
      example = "btrfs";
      description = "What storagedriver docker should use. E.x. zfs, btrfs, overlay;";
    };
  };
  
  config = lib.mkIf config.docker.enable {
    virtualisation.docker = {
      enable = true;
      storageDriver = config.docker.storageDriver;
    };

    # Create internal docker network
    systemd.services.mkInternalNetwork = {
      wantedBy = [ "multi-user.target" ];
      after = [ "docker.service" ];
      wants = [ "docker.service" ];
      description = "Add internal network for internal docker services";
      serviceConfig = {
        Type = "oneshot";
      };

      # This technically means that I can't get errors on failure but I'll
      # implement it later :tm:
      script = "${pkgs.docker}/bin/docker network create internal 2>&1 || true";
    };
    
    users.users.triserden.extraGroups = [ "docker" ];
  };
}
