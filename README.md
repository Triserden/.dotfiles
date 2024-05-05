# Hostnames

- Izumi (Hashima): VPS1
- Megumi (Katou): Main lenovo laptop

# Bootstrap a device

1. Run `nixos-anywhere` with `nix run github:nix-community/nixos-anywhere -- --flake ~/.dotfiles#bootstrapper root@<target_ip>`
2. SSH to device with `ssh -i ~/.ssh/bootstrap-key root@<target_ip>`
3. Run `sudo nix-channel --update`
4. Run `nix-shell -p ssh-to-age --run 'cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age'`
5. Add output to .sops.yaml
6. Update encrypted keys with `nix-shell -p sops --run "sops updatekeys secrets/example.yaml"`

# Add secrets

Use ``nix-shell -p sops --run "sops ./secrets/keys.yaml"
