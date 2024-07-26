{commonModules, config, ...}:

{
  imports = [
    commonModules.home.waybar
    commonModules.home.cli
    commonModules.home.git
    commonModules.home.ssh
    commonModules.home.alacritty
    commonModules.home.hyprland
    commonModules.home.networkmanager-dmenu
    commonModules.home.bluetooth
];
 
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };

    bash.enable = true; # see note on other shells below
  };
  
  sops.defaultSopsFile = ./secrets.yaml;
  home.username = "triserden";
  home.homeDirectory = "/home/triserden";

  # sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  

  home.stateVersion = "23.11"; # Please read the comment before changing. 

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
  };
  
  xdg.enable = true;
 
  xdg.desktopEntries.beekeeper-studio = {
    name = "beekeeper-studio";
    exec = "beekeeper-studio --disable-gpu --enable-features=UseOzonePlatform --ozone-platform=wayland %U";
    icon = "beekeeper-studio";
    type = "Application";
  };

  xdg.desktopEntries.obsidian = {
    name = "Obsidian";
    exec = "obsidian --disable-gpu --enable-features=UseOzonePlatform --ozone-platform=wayland %U";
    icon = "obsidian";
    type = "Application";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
