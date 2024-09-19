{lib, config, ...}: 
{
  options = {
    cli.enable = lib.mkEnableOption "Enable default CLI packages and options.";
  };
  
  config = lib.mkIf config.cli.enable {
    xdg.configFile."nvim".source = ./config/nvim;
  }; 
}
