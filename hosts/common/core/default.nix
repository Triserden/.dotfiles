{ inputs, config, lib, outputs, pkgs, ... }:
{
  imports = lib.flatten [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops

    (lib.custom.scanPaths ./.)
  ];

  hostSpec = {
    username = "triserden"; 
  };

  networking.hostName = config.hostSpec.hostName;

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "bk";
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      connect-timeout = 5;
      log-lines = 25;
      min-free = 250000000;
      max-free = 1000000000;

      trusted-users = ["@wheel"];

      auto-optimise-store = true;
      warn-dirty = false;

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

}
