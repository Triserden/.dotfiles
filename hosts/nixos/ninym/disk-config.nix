{pkgs, lib, ...}:
{
  disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
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
    };

    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          canmount = "off";
        };
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot/root@blank$' || zfs snapshot zroot/root@blank";
        datasets = {
          root = {
            type = "zfs_fs";
            mountpoint = "/";
          };
          nix = {
            type = "zfs_fs";
            mountpoint = "/nix";
          };
          encrypted = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "prompt";
            };
          };
          "encrypted/data" = {
            type = "zfs_fs";
            mountpoint = "/data";
          };
          "encrypted/home" = {
            type = "zfs_fs";
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

  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_12; 
  boot.zfs.requestEncryptionCredentials = true;
}
