{inputs, lib, modulesPath, ...}:
let
  
  hostSpec = {
    hostname = "ninym";
    users = ["triserden"];
    primaryUser = "triserden";
    stateVersion = "25.05";
  };
in 
{
  inherit hostSpec;
  imports = lib.flatten [
    inputs.disko.nixosModules.disko
    ./disk-config.nix
    ./hardware-configuration.nix
    # --- Optionals ---
    (map lib.custom.relativeToRoot [
      "hosts/common/optional/udiskie.nix"
    ])
    (map lib.custom.relativeToRoot ["hosts/common/core"])

  ];

  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    mirroredBoots = [
      { devices = [ "nodev"]; path = "/boot"; }
    ];
  };


  networking.hostId = "1ff873af";
  system.stateVersion = hostSpec.stateVersion;
}
