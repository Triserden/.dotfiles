{ config, ... }: {
  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
    # TODO: Add Github user specific extraConfigs via private flake
  };
  home-manager.users.${config.host.user} = {
    programs.git = {
      enable = true;
      lfs.enable = true;
    };
  };
}
