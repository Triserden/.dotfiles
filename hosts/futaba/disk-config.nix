{
  disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
      nvme1n1 = {
        type = "disk";
        device = "/dev/nvme1n1";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };

    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          canmount = "off";
        };
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot/encrypted/root@blank$' || zfs snapshot zroot/encrypted/root@blank";
        datasets = {
          encrypted = {
            type = "zfs_fs";
            options.mountpoint = "none";
            options.encryption = "aes-256-gcm";
            options.keyformat = "passphrase";
            options.keylocation = "file:///tmp/disk-1.key"; #TODO use nix-anywhere with --disk-encryption-keys
            postCreateHook = ''zfs set keylocation="prompt" "zroot/encrypted"'';
          };
          "encrypted/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
          };
          "encrypted/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "legacy";
          };
          "encrypted/persist" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/persist";
          };
          "encrypted/home" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/home";
          };
        };
      };
    };
  };
  fileSystems = {
    "/".neededForBoot = true;
    "/nix".neededForBoot = true;
    "/home".neededForBoot = true;
    "/boot".neededForBoot = true;
    "/persist".neededForBoot = true;
  };
}

