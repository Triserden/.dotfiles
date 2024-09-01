{
  security.sudo.extraConfig = "Defaults lecture=never";
  system.activationScripts.createPersist = "mkdir -p /nix/persist";
  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/etc/NetworkManager"
      "/var/lib/bluetooth" #TODO at some point persist a host key
    ];
    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };
}

