{lib, config, ...}:
{
  options = {
    user.triserden = {
      enable = lib.mkEnableOption "Enables the Triserden user";
      hashedPassword = lib.mkOption {
        type = lib.types.str;
        description = "A hashed password from `mkpasswd`.";
      };
    };
  };

  config = lib.mkIf config.user.triserden.enable { 
    users.mutableUsers = false;
    users.users.triserden = {
      isNormalUser = true;
      home = "/home/triserden/";
      extraGroups = [ "wheel" "networkmanager"];
      hashedPassword = config.user.triserden.hashedPassword;
    };
  };
}
