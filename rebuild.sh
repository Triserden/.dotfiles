sudo echo "Rebuilding NixOS"

echo "Adding files to git"
git add .
git diff 

sudo nixos-rebuild switch --flake .#megumi --log-format internal-json |& nom --json && nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2)

echo "Commiting to git repo"
current=$(nixos-rebuild list-generations --flake . | grep current)

git commit -am "$current"

echo "Successfully rebuilt. Remember to push."
echo "\033[1;30m$current\033[0m"
