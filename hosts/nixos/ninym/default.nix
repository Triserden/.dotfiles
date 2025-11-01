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
    "./disk-config.nix"
    (modulesPath + "/virtualisation/proxmox-image.nix")
    # --- Optionals ---
    (map lib.custom.relativeToRoot [
      "hosts/common/optional/udiskie.nix"
    ])
    (map lib.custom.relativeToRoot ["hosts/common/core"])

  ];

  proxmox = {
    qemuConf = {
      cores = 6;
      memory = 4096;
      name = hostSpec.hostname;
    };
  };


  services.cloud-init.network.enable = true;


  system.stateVersion = hostSpec.stateVersion;
}
