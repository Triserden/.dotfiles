{commonModules, config, ...}:

{
  imports = [
    commonModules.home.cli
    commonModules.home.git
    commonModules.home.ssh
    commonModules.home.alacritty
  ];
  
  home.username = "triserden";
  home.homeDirectory = "/home/triserden";

  # sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  

  home.stateVersion = "23.11"; # Please read the comment before changing. 

  home.sessionVariables = {
    EDITOR = "nvim";
  };
  
  xdg.enable = true;
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
