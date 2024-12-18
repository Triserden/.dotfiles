{inputs, ...}: {
  imports = [
  ];

  home.username = "triserden";
  home.homeDirectory = "/home/triserden/";
  home.stateVersion = "24.11";
  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
  };

  gui.enable = true;
  cli.enable = true;
  git.enable = true;
  ssh.enable = true;

  xdg.enable = true;

  
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };

    bash.enable = true; # see note on other shells below
  };


  programs.home-manager.enable = true;
  backupFileExtension = ".BAK";
}
