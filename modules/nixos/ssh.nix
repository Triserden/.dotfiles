{lib, config, ...}: 
{
  options = {
    ssh.enable = lib.mkEnableOption "Enable SSH";
  };
  
  config = lib.mkIf config.ssh.enable {
    services.openssh = {
      enable = true;
      # require public key authentication for better security
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
      openFirewall = lib.mkDefault false;
      settings.PermitRootLogin = "no";
    };

    users.users.triserden.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMmlD5B6KzJ8OdGAHtGbrAwmdJ8TSirgQ9RNHicHnGLE"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICymjCefXudYGshKVZEMHkCVv3ogWsUd1UNK4QgJy4E8"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIjFWIdB23LyQW7rDaLJd2tnWPXqYjMjhgEqD/+WVaAQ"
    ];


  };
}
