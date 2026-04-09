A simple ish flake based on [psiri's dotfiles](https://github.com/psiri/nixos-config.git).

TODO:
Add OpSops

# Expanding disk
1. Use `growpart` to expand /dev/sdxy
2. Use `sudo zpool online -e zroot scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-part2` to expand the pool, and thus also the usable storage

# Disko IDs
To get the disk IDs for disko, use this command:
```
lsblk -o NAME,LABEL,FSSIZE,ID-LINK
```

And use the ID-LINK.
