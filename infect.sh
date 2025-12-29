temp=$(mktemp -d)
mkdir -p $temp/etc/ssh/
ssh-keygen -f "$temp/etc/ssh/ssh_host_ed25519_key"
chmod 600 "$temp/etc/ssh/ssh_host_ed25519_key"
echo "Take the age key below and add it to your .sops.yaml and click enter. Once finished, infect system with nixos-anywhere --extra-files "$temp" --flake '.#your-host' --target-host root@yourip"
cat "$temp/etc/ssh/ssh_host_ed25519_key.pub" | ssh-to-age
