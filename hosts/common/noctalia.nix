{ config, inputs, pkgs, ... }: {

  # Installs and sets default settings for noctalia and noctalia-greeter.
  environment.systemPackages =
    [ inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default ];

  services.greetd.enable = true;

  programs.noctalia = {
    enable = true;

    # Enables NetworkManager, Bluetooth, UPower, and a power profile service.
    recommendedServices.enable = true;
    systemd.enable = true;
  };

  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {
      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 24;
        path = pkgs.bibata-cursors;
      };
    };
  };

  # Configuration

  services.displayManager.noctalia-greeter.passwordless-sync-users =
    [ "triserden" ];
  home-manager.users.${config.host.user} = {
    imports = [ inputs.noctalia.homeModules.default ];

    programs.noctalia = {
      enable = true;

      settings = { # This may also be a string or path to a .toml file.A
        shell = {
          launch_apps_as_systemd_services = true;
          setup_wizard_enabled = false;
        };

        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
        };

        wallpaper = {
          enabled = true;
          directory_light = "/home/${config.host.user}/Wallpapers/Light";
          directory_dark = "/home/${config.host.user}/Wallpapers/Dark";
          default.path = "/home/${config.host.user}/Wallpapers/Default.png";

          automation = {
            enabled = true;
            interval_seconds = 1800;
            order = "random";
            recursive = true;
          };
        };
      };
    };
  };
}
