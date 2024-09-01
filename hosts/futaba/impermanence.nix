{
  security.sudo.extraConfig = "Defaults lecture=never";
  system.activationScripts.createPersist = "mkdir -p /nix/persist";
  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/lib/nixos" #TODO: Assign UID/GUIDs to all users/groups
      "/etc/NetworkManager"
      "/var/lib/bluetooth" #TODO at some point persist a host key
    ];
    files = [
      "/etc/ssh/id_ed25519"
      "/etc/ssh/id_ed25519.pub"
    ];
  };
}

