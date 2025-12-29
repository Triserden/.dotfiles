{ config, lib, ... }:
let
  ifExists = groups:
    builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  user = config.host.user;
  sopsHashedPasswordFile = config.sops.secrets."passwords/${user}".path;
in {
  users.users."${config.host.user}" = {

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
  };
  home-manager.users.triserden = {
    programs.home-manager.enable = true;
    home = {
      username = config.host.user;
      homeDirectory = config.host.home;
      stateVersion = config.host.stateVersion;
      sessionVariables = {
        FLAKE = "$HOME/.dotfiles/";
        SHELL = "bash";
        TERM = "foot";
        TERMINAL = "foot";
        VISUAL = "nvim";
        EDITOR = "nvim";
      };
      preferXdgDirectories = true;
    };
  };
}
