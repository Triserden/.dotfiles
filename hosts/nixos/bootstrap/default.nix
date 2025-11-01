{inputs, lib, pkgs, modulesPath, ...}:
{
  imports = lib.flatten [
    # --- Hardware ---
    
   (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") 
    # --- Disko ---

    # --- Optionals ---
  ];

  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.enable = true;
  boot = {
    supportedFilesystems = ["ntrfs" "btrfs"];
    loader = {
      grub = {
        efiInstallAsRemovable = true;                             
        useOSProber = false;                                             
        efiSupport = true;   
      };
      };
  };

  users.users.triserden = {
    hashedPassword = "$y$j9T$QoZU1Mn9vOsDOdru8Hpop/$QkLjqbhBdLAbfsH1JygrEkwev6RVfLDF.GV7MDHqOX/";
    group = "triserden";
    isSystemUser = true;
              openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINxqr4QFoAlWRMtrH7TGTQxwLFqLVDHVsttqrkUHJGuw triserden@megumi"
              ];
            };
users.groups.triserden = {};
  system.stateVersion = "25.05";
}
