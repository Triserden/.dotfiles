{lib, config, ...}: 
{
  options = {
    example.enable = lib.mkEnableOption "Template module.";
  };
  
  config = lib.mkIf config.example.enable {
    #Config here
  };
}
