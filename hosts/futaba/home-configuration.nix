{config, ...}:{
  home = {
    
    # Files to copy to home dir
    file = {
      services = {
        recursive = true;
        source = ./services;
        target = "./services";
        
      };
    };

    username = "triserden";
    homeDirectory = "/home/triserden/";
    stateVersion = "24.05"; 
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs.home-manager.enable = true;
}


