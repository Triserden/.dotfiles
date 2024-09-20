{...}:
{
  # NixOS Modules:
  imports = [
    ./user.nix
    ./docker.nix
    ./tailscale.nix
    ./ssh.nix
    ./cli.nix
    ./git.nix
    ./gui.nix
    ./gpg.nix
    ./printers.nix
    ./nvidia.nix
    ./nwmanager.nix
    ./unstable.nix
  ];
}
