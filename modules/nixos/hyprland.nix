{lib, config, pkgs, inputs, ...}:
{
  services.xserver.displayManager.sddm.enable = true; #This line enables sddm
  services.xserver.enable = true; # Might need this for Xwayland  

  programs.hyprland = { # we use this instead of putting it in systemPackages/users  
    enable = true;  
    xwayland.enable = true;  
    enableNvidiaPatches = lib.mkIf (config.services.xserver.videoDrivers == ["nvidia"]) true; # ONLY use this line if you have an nvidia card  
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # This variable fixes electron apps in wayland

  # I'm putting the login manager here since it's so intertwined with everything else
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # I put these here because I'm not going to use another WM anytime soon
  # TODO: separate these into each own config file
  environment.systemPackages = [
    pkgs.waybar
    
    #(pkgs.waybar.overrideAttrs (oldAttrs: {
    #mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    #  })
    #)
    pkgs.mako
    pkgs.libnotify
    pkgs.swww
    pkgs.fuzzel
  ];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
   
}
