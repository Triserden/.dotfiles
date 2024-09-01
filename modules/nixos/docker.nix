{lib, config, types, ...}: 
{
  options = {
    docker.enable = lib.mkEnableOption "Installs and enables docker on system.";
    docker.storageDriver = lib.mkOption {
      type = types.str;
      example = "btrfs";
      description = "What storagedriver docker should use. E.x. zfs, btrfs, overlay;";
    };
  };
  
  config = lib.mkIf config.docker.enable {
    virtualisation.docker.enable = true;
    users.users.triserden.extraGroups = [ "docker" ];
  } (
    if (config.docker.storagedriver == "btrfs") then {
      # TODO: Verify that config works
      virtualisation.docker.storageDriver = "btrfs";
    } else if (config.docker.storageDriver == "zfs") then {
      virtualisation.docker.storageDriver = "zfs";
    } else {

    }
  );
}
