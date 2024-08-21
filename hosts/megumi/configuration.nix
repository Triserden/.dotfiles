{sops, config, pkgs}:
{

  # Enable user and pass password to module
  sops.secrets.triserden_megumi_password.neededForUsers = true;
  user.triserden = {
    enable = true;
    hashedPasswordFile = config.sops.secrets.triserden_megumi_password.path;
  };
}
