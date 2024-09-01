{...}:
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-TEAM_TM8FP4001T_TPBF2108200041000396";
        content = {
          type = "gpt";
          partitions = {
            # MBR Boot Record
            # Apparently disko doesn't reserve this?
            # Guide's probably outdated but it's just 1M anyway
            boot = {
              size = "1M";
              type = "EF02"; #EF02 is type GRUB MBR
            };
            
            # ESP Partition of main disk
            ESP = {
              size = "512M";
              type = "EF00"; # EF00 is type EFI System
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
              };
            };

            # LUKS+BTRFS Partition of main disk
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ]; # Flushes data for each file before writing next file.
                                        # Minirant: I hate waiting for large files to flush with a passion.
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [ "compress=zstd" "noatime" ]; #I'll confess: No clue what noatime does. 
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [ "compress=zstd" "noatime" ]; 
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "compress=zstd" "noatime" ]; 
                    };
                    "/swap" = {
                      mountpoint = "/.swapvol";
                      swap.swapfile.size = "6G";
                    };
                    
                    "/log" = {
                      mountpoint = "/var/log";
                      mountOptions = [ "compress=zstd" "noatime" ]; 
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}

