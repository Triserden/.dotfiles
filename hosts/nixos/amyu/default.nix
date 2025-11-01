{inputs, lib, pkgs, modulesPath, ...}:
let
  
  hostSpec = {
    hostname = "amyu";
    users = ["triserden"];
    primaryUser = "triserden";
    stateVersion = "25.05";
  };
in 
{
  inherit hostSpec;
  imports = lib.flatten [
    # --- Hardware ---
   (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") 
    # --- Disko ---
    # --- Optionals ---
    (map lib.custom.relativeToRoot [
    ])

  ];


  networking = {
  };


  boot = {
    loader = {
      grub.enable = false;
      };
  };

  system.stateVersion = hostSpec.stateVersion;
}
