{ commonModules, ... }: 

{
  # Import other modules
  imports = [
    commonModules.home.cli
    commonModules.home.git
  ];

  home.username = "triserden";
  home.homeDirectory = "/home/triserden";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  

  home.sessionVariables = {
    EDITOR = "nvim";
  };
  
  xdg.enable = true;
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
