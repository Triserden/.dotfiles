{pkgs, ...}:
{
  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    # winetricks (all versions)
    winetricks
    # native wayland support (unstable)
    wineWowPackages.waylandFull
    
   (pkgs.buildFHSEnv {
     name = "prismlauncher";
     targetPkgs = pkgs: (with pkgs; [
      nss.dev
      nspr
      mesa
      alsa-lib
      libcef
      unstable.prismlauncher
     ]);

    runScript = "prismlauncher";
  }) 

    #(unstable.prismlauncher.override { 
    #  additionalLibs = [
    #      nss
    #      nspr
    #      mesa
    #      alsa-lib
    #      libcef
    #      #glib.out
    #    ];
      
      #additionalPrograms = [
      #    ungoogled-chromium
      #    chromedriver
      #  ];
    #  }
    #)

  ];
}
