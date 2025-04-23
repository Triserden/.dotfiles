{lib, config, ...}: 
{
  options = {
    hyprland.enable = lib.mkEnableOption "Enable hyperland and it's standard config.";
  };
  
  config = lib.mkIf config.hyprland.enable {
    programs.hyprland = { # we use this instead of putting it in systemPackages/users  
      enable = true;  
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    
  };
}
