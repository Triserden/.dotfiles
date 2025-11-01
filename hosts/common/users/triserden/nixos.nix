{config, lib, user, ...}:
let
  ifExists = groups: builtins.filter(group: builtins.hasAttr group config.users.groups) groups;
  sopsHashedPasswordFile = config.sops.secrets."passwords/${user}".path;
in 
{
      home = "/home/${user}";
      isNormalUser = true;
      hashedPasswordFile = sopsHashedPasswordFile;
      name = user;

      extraGroups = lib.flatten [
        "wheel"
        (ifExists [
          "audio"
          "video"
          "docker"
          "git"
          "networkmanager"
          "scanner"
          "lp"
        ])
      ];

}
