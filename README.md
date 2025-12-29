A simple ish flake based on [psiri's dotfiles](https://github.com/psiri/nixos-config.git).


# Disko IDs
To get the disk IDs for disko, use this command:
```
lsblk -o NAME,LABEL,FSSIZE,ID-LINK
```

And use the ID-LINK.
