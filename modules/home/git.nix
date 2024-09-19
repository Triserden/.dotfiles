{lib, config, ...}: 
{
  options = {
    git.enable = lib.mkEnableOption "Template module.";
  };
  
  config = lib.mkIf config.git.enable {
    programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Triserden";
    userEmail = "triserden@gmail.com";
    
    extraConfig = {
      commit.gpgsign = true;
      user.signingkey = "46CC369C9264F713";
    };
  };
  }; 
}
