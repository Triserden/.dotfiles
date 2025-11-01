{pkgs, lib, ...}:
{
  disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-QEMU_HARDDISK_QM00005";
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
          mountpoint = "none";
          compression = "zstd";
          acltype = "posixacl";
          xattr = "sa";
          "com.sun:auto-snapshot" = "true";
        };
        options.ashift = "12";
        datasets = {
          "root" = {
            type = "zfs_fs";
            options = {
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              #keylocation = "file:///tmp/secret.key";
              keylocation = "prompt";
            };
            mountpoint = "/";

          };
          "root/nix" = {
            type = "zfs_fs";
            options.mountpoint = "/nix";
            mountpoint = "/nix";
          };
          "root/home" = {
            type = "zfs_fs";
            options.mountpoint = "/home";
            mountpoint = "/home";
          };
          "root/data" = {
            type = "zfs_fs";
            options.mountpoint = "/data";
            mountpoint = "/data";
          };

          # README MORE: https://wiki.archlinux.org/title/ZFS#Swap_volume
          "root/swap" = {
            type = "zfs_volume";
            size = "16G";
            content = {
              type = "swap";
            };
            options = {
              volblocksize = "4096";
              compression = "zle";
              logbias = "throughput";
              sync = "always";
              primarycache = "metadata";
              secondarycache = "none";
              "com.sun:auto-snapshot" = "false";
            };
          };
        };
      };
    };
  };

  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_12; 
}
