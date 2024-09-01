{lib, config, ...}: 
{
  options = {
    example.enable = lib.mkEnableOption "Template module.";
  };
  
  config = lib.mkIf config.example.enable {
    #Config here
  } (
    if (config.example2 == true) then {
      # Note: No clue if this actually works
    } else {
      # Don't do anything
    }
  );
}
