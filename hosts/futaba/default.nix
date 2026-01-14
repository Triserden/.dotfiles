let
  host = {
    hostname = "futaba";
    user = "triserden";
    hostId = "713ebefd";
    stateVersion = "25.11";
    home = "/home/${host.user}";
    docker_fs = "zfs";
  };
in { inputs, ... }: {
  inherit host;
  imports = [
    ../common

    ../../users/${host.user}.nix

    ./hardware-configuration.nix
    ./disk-config.nix

    ../../programs/docker.nix
    ./services

  ];

  # Virt
  services.qemuGuest.enable = true;
  virtualisation.virtualbox.guest.enable = true;

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
