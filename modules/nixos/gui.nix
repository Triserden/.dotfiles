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
      pkgs.nemo
      pkgs.brightnessctl
      pkgs.starship
    ];

    programs.foot = {
      enable = true;
      theme = "catppuccin-macchiato";
      # TODO: Style foot
      # https://mynixos.com/home-manager/option/programs.foot.settings
    };
    hyprland.enable = true;

    # Main config?
    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    services.xserver.enable = true; # Might need this for Xwayland  
    environment.sessionVariables.NIXOS_OZONE_WL = "1"; # This variable fixes electron apps in wayland

    stylix = lib.mkForce {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
      polarity = "dark";
      image = pkgs.fetchurl {
        url = "https://whvn.cc/yxgyyx";
        sha256 = "sha256-lW95raJ6XFqpJb4FBWo6gt6jPDw7rDcFjpKqDNNAQik=";
      };
      fonts = {
        monospace = {
          package = pkgs.unstable.nerd-fonts.jetbrains-mono;
          name = "Nerd Fonts: Jetbrains";
        };
      };
      opacity = {
        terminal = 0.6;
        applications=0.6;
      };
    };


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
