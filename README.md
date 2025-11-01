# Triserden's .dotfiles
> Totally not rewriting because I rm -r'd the repo months after not pushing it to github aha

Inspired by [EmergenMind's repo](https://github.com/EmergentMind/nix-config)

# Hosts
Names are just some random characters in my Anilist. May change depending on how I feel.

## Megumi
My main laptop (IdeaPad Gaming 3 15ACH6)

## Futaba
My offsite Hetzner dedicated server, hosts a few containers but biggest service is minecraft. Looking at options to decomission, not sure yet.

## Proxmox
I did't name this one but I don't think I'll even use the name often so eh
### Ninym
My future container host, looking to move most of my services from Futaba over to this one.

# Adding hosts
1. Install any linux distro with kexec/nixos-anywhere support (Ubuntu, debian, etc)
2. Make temporary ramfs (`temp=$(mktemp -d)`)
3. Make new OpenSSH Host Key for secrets decryption (In ramfs!) at "$temp/etc/ssh/ssh_host_ed25519_key" (`mkdir -p $temp/etc/ssh/; ssh-keygen -f "$temp/etc/ssh/ssh_host_ed25519_key"`)
4. Get age key from host key with ssh-to-age for sops-nix (`'cat "$temp/etc/ssh/ssh_host_ed25519_key.pub" | ssh-to-age'`) (it might be better to enter shell with ssh-to-age first, env vars don't carry over)
5. Add age key to .sops.yaml
6. Add new creation rules for new host
7. Add secrets for new host
    - Tailscale
    - User password (mkpasswd)
8. Install on host with nixos-anywhere with option --extra-files "$temp"

# Todo:
- [ ] Add megumi
- [ ] Add unstable pkgs
- [ ] Add formatting and pre-checks
- [ ] Add triserden
- [ ] Test deployment with a VM
- [ ] Add home-manager entru point
- [ ] Finish hostSpec
