{sops, config, pkgs}:
{
  imports = [
    ./disk-config.nix
    ./impermanence.nix
  ];

  # Setup sops-nix
  sops.defaultSopsFile = ./secrets.yaml;

  ## === User ===
  # Enable user and pass password to module
  sops.secrets.triserden_futaba_password.neededForUsers = true;
  user.triserden = {
    enable = true;
    hashedPasswordFile = config.sops.secrets.triserden_yuki_password.path;
  };


  ## === Config ===
  docker = {
    enable = true;
    storageDriver = "zfs";
  };

  sops.secrets.tailscale_key = {};
  tailscale = {
    enable = true;
    keyfile = config.sops.secrets.tailscale_key;
  };

}
