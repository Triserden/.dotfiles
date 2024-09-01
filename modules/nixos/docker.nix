{lib, config, ...}: 
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
    users.users.triserden.extraGroups = [ "docker" ];
  };
}
