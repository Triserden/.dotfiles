{lib, config, types, ...}:
{
  options = {
    user.triserden = {
      enable = lib.mkEnableOption "Enables the Triserden user";
      hashedPasswordFile = lib.mkOption {
        type = types.path;
        description = "A file containing the hashed password for this user. Used with sops-nix or equivalent."
      };
    };
  };

  config = lib.mkIf config.user.triserden.enable {   
    users.users.triserden = {
      isNormalUser = true;
      home = "/home/triserden/";
      extraGroups = [ "wheel" "networkmanager" "docker"];
      hashedPasswordFile = config.user.triserden.hashedPasswordFile;
    };
  };
}
