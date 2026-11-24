{ ... }: {
  boot.supportedFilesystems = [ "nfs" ];
  fileSystems = {
    "/home/triserden/Datastore" = {
      device = "truenas.local.triserden.dev/datastore";
      fsType = "nfs";
    };
  };
}
