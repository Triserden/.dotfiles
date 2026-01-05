let
  host = {
    hostname = "sora";
    user = "triserden";
    hostId = "40ae7f3c";
    stateVersion = "25.11";
    home = "/home/${host.user}";
  };
in { inputs, ... }: {
  inherit host;
  imports = [
    ../common

    ../../users/${host.user}.nix

    ./hardware-configuration.nix
    ./disk-config.nix

    ../../programs/docker.nix

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
