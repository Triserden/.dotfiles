echo "Rebuilding NixOS"

echo "Adding files to git"
git add .
git diff *.nix

echo "Rebuilding"
sudo nixos-rebuild switch --flake . "$@" &&  nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2)
# https://discourse.nixos.org/t/nvd-simple-nix-nixos-version-diff-tool/12397/33

echo "Commiting to git repo"
current=$(nixos-rebuild list-generations | grep current)

git commit -am "$current"

echo "Commited to repo and finished rebuilding. Remember to push."
