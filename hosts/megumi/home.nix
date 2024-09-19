{inputs, ...}: {
  imports = [
  ];

  home.username = "triserden";
  home.homeDirectory = "/home/triserden/";
  home.stateVersion = "24.05";
  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
  };
  
  gui.enable = true;
  cli.enable = true;
  git.enable = true;
  ssh.enable = true;

  xdg.enable = true;
  programs.home-manager.enable = true;
}
