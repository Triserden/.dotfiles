{
  security.sudo.extraConfig = "Defaults lecture=never";
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/srv"
      "/var/lib"
      "/var/log"
    ];
  };
  
  # We need to hardlink it or else the system will make it 
  environment.etc = {
    "machine-id".source = "/persist/etc/machine-id";
    "ssh/ssh_host_rsa_key".source = "/persist/etc/ssh/ssh_host_rsa_key";
    "ssh/ssh_host_rsa_key.pub".source = "/persist/etc/ssh/ssh_host_rsa_key.pub";
    "ssh/ssh_host_ed25519_key".source = "/persist/etc/ssh/ssh_host_ed25519_key";
    "ssh/ssh_host_ed25519_key.pub".source = "/persist/etc/ssh/ssh_host_ed25519_key.pub";
  };
}

