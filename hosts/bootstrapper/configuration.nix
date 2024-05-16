

{ commonModules, modulesPath, ... }:

{
  imports =
    [
      (modulesPath+"/profiles/qemu-guest.nix")
      (modulesPath + "/installer/scan/not-detected.nix")
      ./disk-config.nix
      commonModules.nixos.git
    ];

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings.PasswordAuthentication = false;
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICCG7lTuHjzSp57sgrVz/dbGP5zHC5isZx9gcEI+ZlgW triserden@lenovolaptop"
  ];

  networking.hostName = "bootstrapper"; # Define your hostname.
}
