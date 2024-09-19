{lib, config, ...}: 
{
  config = lib.mkIf config.example.enable {
    #Config here
  }; 
}
