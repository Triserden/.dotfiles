{lib, config, ...}: 
{
  options = {
    git.enable = lib.mkEnableOption "Template module.";
  };
  
  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      lfs.enable = true;
    };
  };
}
