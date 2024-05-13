{lib, config, ...}:
{
  services.xserver.displayManager.sddm.enable = true; #This line enables sddm
  services.xserver.enable = true; # Might need this for Xwayland  

  programs.hyprland = { # we use this instead of putting it in systemPackages/users  
    enable = true;  
    xwayland.enable = true;  
    nvidiaPatches = lib.mkIf (config.services.xserver.videoDrivers == ["nvidia"]) true; # ONLY use this line if you have an nvidia card  
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # This variable fixes electron apps in wayland
}
