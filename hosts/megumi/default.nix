let
  host = {
    hostname = "megumi";
    user = "triserden";
    hostId = "1ff873af";
    stateVersion = "26.05";
    home = "/home/${host.user}";
    docker_fs = "btrfs";
  };
in { inputs, pkgs, lib, ... }: {
  inherit host;
  imports = [
    ../common

    ../../users/${host.user}.nix

    ./hardware-configuration.nix
    ./disk-config.nix
    ../common/noctalia.nix
    ../common/hyprland

    ../../programs/docker.nix

  ];

  # Virt
  services.qemuGuest.enable = true;
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.vmVariantWithDisko = {
    # the following configuration is added only when building VM with `build-vm`
    users.users.root.initialPassword = "rootpswd";
    users.users.triserden.password = "12345";

    virtualisation = {

      fileSystems."/home".neededForBoot = true;
      memorySize = 2048; # use 2048MiB memory
      cores = 3; # use 3 cpu cores
      #fileSystems."/boot".device = lib.mkForce "/dev/vda";
    };

  };

  # Boot
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    #efiInstallAsRemovable = true;
    mirroredBoots = [{
      devices = [ "nodev" ];
      path = "/boot";
    }];
  };
}
