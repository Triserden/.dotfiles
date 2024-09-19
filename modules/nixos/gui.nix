{lib, pkgs, config, ...}: 
{
  # TODO in the future: Check if I need multiple "profiles" or if one switch for GUI is enough
  options = {
    gui.enable = lib.mkEnableOption "Enable the GUI (Hyprland) and it's required packages";
  };
  
  config = lib.mkIf config.gui.enable {
    ## == Hyprland ==
    environment.systemPackages = [
    # Desktop stuff
      pkgs.waybar
      pkgs.mako
      pkgs.libnotify
      pkgs.swww
      pkgs.fuzzel
      pkgs.grimblast
      pkgs.cinnamon.nemo
      pkgs.brightnessctl
      pkgs.starship
    ];

    # Main config?
    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    programs.hyprland = { # we use this instead of putting it in systemPackages/users  
      enable = true;  
      xwayland.enable = true;  
      enableNvidiaPatches = lib.mkIf (config.services.xserver.videoDrivers == ["nvidia"]) true; # ONLY use this line if you have an nvidia card  
    };
    services.xserver.enable = true; # Might need this for Xwayland  
    environment.sessionVariables.NIXOS_OZONE_WL = "1"; # This variable fixes electron apps in wayland


    # Note: IDK what this is doing here but I probably need it
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    programs.waybar.enable = true;
  
    ## == Greeter ==
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
          user = "greeter";
        };
      };
    };
  };

}
