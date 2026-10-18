A simple ish flake based on [psiri's dotfiles](https://github.com/psiri/nixos-config.git).

TODO:
- Add OpSops
- Refactor docker services to use `config.docker.networks.<name>` or something to reduce boilerplate systemd stuff
- Same as above, but with volumes

# Expanding disk
1. Use `growpart` to expand /dev/sdxy
2. Use `sudo zpool online -e zroot scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-part2` to expand the pool, and thus also the usable storage

# Disko IDs
To get the disk IDs for disko, use this command:
```
lsblk -o NAME,LABEL,FSSIZE,ID-LINK
```

And use the ID-LINK.

# Adding docker (compose) services

Write docker compose with `virtualisation.oci-containers.containers` and add secrets with sops-nix. See traefik.nix for an example.

Note: old notes below, kept for lazy times
Write a docker compose file with the whole service stack, then run `compose2nix` to convert it to a nix file.
```
compose2nix --runtime=docker -output <project>.nix -inputs docker-compose.yaml -sops_file ~/.secrets/sops/<host>.yaml
```

