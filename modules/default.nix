{...}:
{
  # NixOS Modules:
  imports = [
    ./nixos/user.nix
    ./nixos/docker.nix
    ./nixos/tailscale.nix
    ./nixos/ssh.nix
  ];
}
