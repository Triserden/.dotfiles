let
  host = {
    hostname = "megumi";
    user = "triserden";
    hostId = "1ff873af";
    stateVersion = "26.05";
    home = "/home/${host.user}";
    docker_fs = "btrfs";
  };
in { inputs, ... }: {
  inherit host;
  imports = [
    ../common

    ../../users/${host.user}.nix

    ./hardware-configuration.nix
    ./disk-config.nix
    ../common/noctalia.nix

    ../../programs/docker.nix

  ];

  # Virt
  services.qemuGuest.enable = true;
  virtualisation.virtualbox.guest.enable = true;

  virtualisation.vmVariantWithBootLoader = {
    # the following configuration is added only when building VM with `build-vm`
    users.users.testuser.isSystemUser = true;
    users.users.testuser.initialPassword = "testpassword";

    virtualisation = {
      memorySize = 2048; # use 2048MiB memory
      cores = 3; # use 3 cpu cores
    };
  };

  # Boot
  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    mirroredBoots = [{
      devices = [ "nodev" ];
      path = "/boot";
    }];
  };
}
