{lib, config, ...}: 
{
  options.example.enable = lib.mkEnableOption "Template.";
  
  config = lib.mkIf config.example.enable {
    #Config here
  }; 
}
