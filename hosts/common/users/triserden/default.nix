{inputs, pkgs, config, lib, ...}:
let
  hostSpec = config.hostSpec;
  ifExists = groups: builtins.filter(group: builtins.hasAttr group config.users.groups) groups;
  sopsHashedPasswordFile = config.sops.secrets."passwords/${hostSpec.username}".path;
in 
{
  users = {
    mutableUsers = false;
    users.${hostSpec.username} = {
      home = "/home/${hostSpec.username}";
      isNormalUser = true;
      hashedPasswordFile = sopsHashedPasswordFile;
      name = hostSpec.username;

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
    };
  };

  programs.git.enable = true;

users.users.${config.hostSpec.username} = {
  };

  environment.systemPackages = [
      pkgs.just
      pkgs.tree
      pkgs.btop
      pkgs.unzip
    ];

  home-manager = {
    extraSpecialArgs = {
      inherit pkgs inputs;
      hostSpec = config.hostSpec;
    };
    users.${hostSpec.username} = {
      home.stateVersion = 25.05; 
      imports = lib.flatten (
        import (lib.custom.relativeToRoot "home/${hostSpec.username}/${hostSpec.hostname}.nix") {
          inherit pkgs inputs config lib hostSpec;
        }
      );
    };
  };
}
